#!/bin/bash
set -euo pipefail

APP_NAME="ViewMD"
ARM_TRIPLE="arm64-apple-macosx13.0"
INTEL_TRIPLE="x86_64-apple-macosx13.0"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_DIR"

notarize=false
require_release_signing=false
skip_archive=false
unsigned_public_beta=false

usage() {
    cat <<'USAGE'
Usage: scripts/release-build.sh [options]

Builds a universal ViewMD.app, signs it, optionally notarizes it, and creates
a release zip plus SHA-256 checksum under ViewMD/build/dist/.

Options:
  --unsigned-public-beta     Create an ad-hoc signed unsigned public beta zip.
  --notarize                 Submit the release zip to Apple's notary service.
  --require-release-signing  Fail unless a Developer ID Application identity is used.
  --skip-archive             Build and sign the app bundle without creating a zip.
  --help                     Show this help text.

Environment:
  VIEWMD_SIGN_IDENTITY       Signing identity. Defaults to the first Developer ID
                             Application identity in the keychain, or ad-hoc if absent.
  VIEWMD_NOTARY_PROFILE      notarytool keychain profile name.
  VIEWMD_APPLE_ID            Apple ID for notarytool fallback auth.
  VIEWMD_APPLE_TEAM_ID       Apple team ID for notarytool fallback auth.
  VIEWMD_APPLE_PASSWORD      App-specific password for notarytool fallback auth.
USAGE
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --unsigned-public-beta)
            unsigned_public_beta=true
            ;;
        --notarize)
            notarize=true
            ;;
        --require-release-signing)
            require_release_signing=true
            ;;
        --skip-archive)
            skip_archive=true
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage >&2
            exit 2
            ;;
    esac
    shift
done

version="$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" Info.plist)"
build_number="$(/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" Info.plist)"

if [[ "$unsigned_public_beta" == true && "$notarize" == true ]]; then
    echo "--unsigned-public-beta cannot be combined with --notarize." >&2
    exit 2
fi

if [[ "$unsigned_public_beta" == true && "$require_release_signing" == true ]]; then
    echo "--unsigned-public-beta cannot be combined with --require-release-signing." >&2
    exit 2
fi

build_root="$PROJECT_DIR/build"
app_dir="$build_root/$APP_NAME.app"
contents_dir="$app_dir/Contents"
macos_dir="$contents_dir/MacOS"
resources_dir="$contents_dir/Resources"
dist_dir="$build_root/dist"
zip_suffix="mac-universal"
if [[ "$unsigned_public_beta" == true ]]; then
    zip_suffix="mac-universal-unsigned"
fi
zip_name="$APP_NAME-$version-$zip_suffix.zip"
zip_path="$dist_dir/$zip_name"
checksum_path="$dist_dir/$zip_name.sha256"

echo "Building $APP_NAME $version ($build_number) for $ARM_TRIPLE..."
swift build -c release --triple "$ARM_TRIPLE" --product "$APP_NAME"

echo "Building $APP_NAME $version ($build_number) for $INTEL_TRIPLE..."
swift build -c release --triple "$INTEL_TRIPLE" --product "$APP_NAME"

arm_bin_dir="$(swift build -c release --triple "$ARM_TRIPLE" --show-bin-path)"
intel_bin_dir="$(swift build -c release --triple "$INTEL_TRIPLE" --show-bin-path)"
arm_binary="$arm_bin_dir/$APP_NAME"
intel_binary="$intel_bin_dir/$APP_NAME"
resource_bundle="$arm_bin_dir/${APP_NAME}_${APP_NAME}.bundle"

if [[ ! -x "$arm_binary" || ! -x "$intel_binary" ]]; then
    echo "Missing architecture-specific build output." >&2
    exit 1
fi

echo "Creating app bundle..."
rm -rf "$app_dir"
mkdir -p "$macos_dir" "$resources_dir"

lipo -create "$arm_binary" "$intel_binary" -output "$macos_dir/$APP_NAME"
chmod 755 "$macos_dir/$APP_NAME"

cp "Info.plist" "$contents_dir/Info.plist"

if [[ -f "AppIcon.icns" ]]; then
    cp "AppIcon.icns" "$resources_dir/AppIcon.icns"
fi

if [[ -d "$resource_bundle" ]]; then
    cp -R "$resource_bundle" "$resources_dir/${APP_NAME}_${APP_NAME}.bundle"
else
    echo "Missing resource bundle: $resource_bundle" >&2
    exit 1
fi

sign_identity="${VIEWMD_SIGN_IDENTITY:-}"
if [[ "$unsigned_public_beta" == true ]]; then
    sign_identity="-"
elif [[ -z "$sign_identity" ]]; then
    sign_identity="$(security find-identity -v -p codesigning 2>/dev/null | awk -F '"' '/Developer ID Application/ { print $2; exit }')"
fi

if [[ -z "$sign_identity" ]]; then
    sign_identity="-"
    signing_mode="ad-hoc"
else
    signing_mode="$sign_identity"
fi

if [[ "$require_release_signing" == true && "$sign_identity" != Developer\ ID\ Application:* ]]; then
    echo "Release signing requested, but no Developer ID Application identity is available." >&2
    echo "Set VIEWMD_SIGN_IDENTITY='Developer ID Application: ...' after installing the certificate." >&2
    exit 1
fi

if [[ "$notarize" == true && "$sign_identity" == "-" ]]; then
    echo "Notarization requires Developer ID signing; ad-hoc signing is not acceptable." >&2
    exit 1
fi

echo "Signing app bundle with: $signing_mode"
if [[ "$sign_identity" == "-" ]]; then
    codesign --force --deep --sign - "$app_dir"
else
    codesign --force --deep --options runtime --timestamp --sign "$sign_identity" "$app_dir"
fi

codesign --verify --deep --strict --verbose=2 "$app_dir"
lipo -info "$macos_dir/$APP_NAME"

archive_release() {
    mkdir -p "$dist_dir"
    rm -f "$zip_path" "$checksum_path"
    (
        cd "$build_root"
        ditto -c -k --sequesterRsrc --keepParent "$APP_NAME.app" "$zip_path"
    )
    (
        cd "$dist_dir"
        shasum -a 256 "$zip_name" > "$zip_name.sha256"
    )
}

if [[ "$skip_archive" == true ]]; then
    echo "App bundle created at: $app_dir"
    exit 0
fi

archive_release

if [[ "$notarize" == true ]]; then
    echo "Submitting $zip_name for notarization..."
    if [[ -n "${VIEWMD_NOTARY_PROFILE:-}" ]]; then
        xcrun notarytool submit "$zip_path" \
            --keychain-profile "$VIEWMD_NOTARY_PROFILE" \
            --wait
    elif [[ -n "${VIEWMD_APPLE_ID:-}" && -n "${VIEWMD_APPLE_TEAM_ID:-}" && -n "${VIEWMD_APPLE_PASSWORD:-}" ]]; then
        xcrun notarytool submit "$zip_path" \
            --apple-id "$VIEWMD_APPLE_ID" \
            --team-id "$VIEWMD_APPLE_TEAM_ID" \
            --password "$VIEWMD_APPLE_PASSWORD" \
            --wait
    else
        echo "Missing notary credentials. Set VIEWMD_NOTARY_PROFILE or VIEWMD_APPLE_ID/VIEWMD_APPLE_TEAM_ID/VIEWMD_APPLE_PASSWORD." >&2
        exit 1
    fi

    echo "Stapling notarization ticket..."
    xcrun stapler staple "$app_dir"
    xcrun stapler validate "$app_dir"
    spctl -a -vvv -t install "$app_dir"

    echo "Re-archiving stapled app..."
    archive_release
fi

echo "Release artifact: $zip_path"
echo "Checksum: $checksum_path"
