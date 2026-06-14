# ViewMD 1.0.0: Read and export AI-generated Markdown on your Mac

ViewMD turns AI-generated Markdown files into polished Mac documents. Open a `.md` file, read it in a clean PDF-style view, then export a shareable PDF beside the source file.

This first public beta is for technical Mac users who receive Markdown from AI tools, coding agents, chat exports, research assistants, or automated report generators.

## Unsigned Public Beta Notice

This build is unsigned and not notarized because ViewMD is not yet distributed through the paid Apple Developer Program. macOS will warn before opening it.

If you are not comfortable opening an unsigned Mac app, use the build-from-source path instead.

## Download

Download the universal Mac build from this release:

- `ViewMD-1.0.0-mac-universal-unsigned.zip`
- `ViewMD-1.0.0-mac-universal-unsigned.zip.sha256`

The notarized release artifact will use `ViewMD-1.0.0-mac-universal.zip` in a future Developer ID-signed release.

## Install Unsigned Build

1. Download `ViewMD-1.0.0-mac-universal-unsigned.zip` and the `.sha256` file.
2. Verify the checksum:
   ```bash
   shasum -a 256 -c ViewMD-1.0.0-mac-universal-unsigned.zip.sha256
   ```
3. Unzip the file.
4. Move `ViewMD.app` to Applications.
5. Try opening ViewMD once.
6. If macOS blocks it, use Apple's per-app override: **System Settings -> Privacy & Security -> Open Anyway**.
7. Right-click a `.md` file and choose **Open With -> ViewMD**.

To make ViewMD the default app for Markdown files, open Finder's **Get Info** panel for a `.md` file, choose ViewMD under **Open with**, then choose **Change All**.

Apple guidance:

- Unknown developer override: https://support.apple.com/guide/mac-help/open-a-mac-app-from-an-unknown-developer-mh40616/mac
- Safe app opening guidance: https://support.apple.com/en-us/102445
- Mac distribution overview: https://developer.apple.com/macos/distribution/

## Build From Source

For technical users, building locally is the cleaner trust path:

```bash
git clone https://github.com/cdraarsh/viewmd.git
cd viewmd/ViewMD
swift test
./build-app.sh --unsigned-public-beta
```

## Included

- Native macOS app for Markdown files.
- Finder-friendly `.md`, `.markdown`, `.mdown`, and `.mkd` file opening.
- Polished reading view for reports, plans, specs, notes, and research.
- Markdown rendering for headings, lists, tables, links, images, code blocks, and task lists.
- PDF export next to the source file.
- Overwrite confirmation before replacing an existing PDF.
- Local-first workflow. File contents stay on your Mac.

## Known Limitations

- ViewMD is reader-first. It is not a Markdown editor.
- This release is distributed outside the Mac App Store.
- This public beta is unsigned and not notarized.
- Large files may take longer to render or export.
- Some Markdown extensions may not match every AI tool's preview exactly.

## Feedback

After trying the app, please share:

1. Where your Markdown file came from.
2. Whether you opened your own file.
3. Whether you exported a PDF.
4. The first confusing step or blocker.
5. Whether you would use ViewMD again.

Feedback form: https://github.com/cdraarsh/viewmd/issues/new?template=feedback.yml  
Bug report: https://github.com/cdraarsh/viewmd/issues/new?template=bug_report.yml
