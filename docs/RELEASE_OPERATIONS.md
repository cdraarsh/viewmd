# ViewMD Release Operations

Use this when producing the public GitHub Release artifact.

## Unsigned Public Beta Path

This is the active release path until ViewMD has paid Apple Developer Program access.

Local build:

```bash
./scripts/release-build.sh --unsigned-public-beta
```

GitHub Actions build:

1. Push the repo to `cdraarsh/viewmd`.
2. Run the **Release** workflow.
3. Use tag `v1.0.0`.
4. Choose `distribution = unsigned-public-beta`.
5. Keep `draft = true` until the downloaded artifact has been tested.

The unsigned public beta artifacts are:

- `ViewMD/build/dist/ViewMD-1.0.0-mac-universal-unsigned.zip`
- `ViewMD/build/dist/ViewMD-1.0.0-mac-universal-unsigned.zip.sha256`

macOS will warn users because this build is not notarized. Do not tell users to disable Gatekeeper globally. Use Apple's per-app override instructions only.

Apple guidance: https://support.apple.com/guide/mac-help/open-a-mac-app-from-an-unknown-developer-mh40616/mac

## Future Notarized Release Path

Use this path after joining the paid Apple Developer Program.

### Required Apple Credentials

Local release signing requires:

- Apple Developer Program membership.
- Developer ID Application certificate installed in the login keychain.
- Notary credentials stored in a notarytool profile or provided through environment variables.

Recommended local notary profile setup:

```bash
xcrun notarytool store-credentials viewmd-notary \
  --apple-id "<apple-id-email>" \
  --team-id "<team-id>" \
  --password "<app-specific-password>"
```

Then build:

```bash
VIEWMD_SIGN_IDENTITY="Developer ID Application: <name> (<team-id>)" \
VIEWMD_NOTARY_PROFILE="viewmd-notary" \
./scripts/release-build.sh --require-release-signing --notarize
```

### GitHub Actions Secrets

The release workflow expects these repository secrets:

- `APPLE_DEVELOPER_ID_SIGNING_IDENTITY`
- `APPLE_DEVELOPER_ID_CERTIFICATE_BASE64`
- `APPLE_DEVELOPER_ID_CERTIFICATE_PASSWORD`
- `APPLE_BUILD_KEYCHAIN_PASSWORD`
- `APPLE_ID`
- `APPLE_TEAM_ID`
- `APPLE_APP_SPECIFIC_PASSWORD`

To create `APPLE_DEVELOPER_ID_CERTIFICATE_BASE64`, export the Developer ID Application certificate as a `.p12` from Keychain Access, then encode it:

```bash
base64 -i DeveloperIDApplication.p12 | pbcopy
```

### GitHub Release

Manual notarized release path:

1. Push the repo to `cdraarsh/viewmd`.
2. Configure the secrets above.
3. Run the **Release** workflow with tag `v1.0.0`, `distribution = notarized-release`, and `draft = true`.
4. Download and test the draft release asset on a clean Mac account.
5. Publish the draft release after install QA passes.

The notarized release artifacts are:

- `ViewMD/build/dist/ViewMD-1.0.0-mac-universal.zip`
- `ViewMD/build/dist/ViewMD-1.0.0-mac-universal.zip.sha256`

## Homebrew Cask

After the final unsigned or signed zip is available, update `packaging/homebrew/Casks/viewmd.rb`:

1. Confirm the `sha256` value matches the final release zip.
2. Commit the cask into a first-party tap, for example `cdraarsh/homebrew-viewmd`.
3. Test with `brew install --cask ./Casks/viewmd.rb`.
