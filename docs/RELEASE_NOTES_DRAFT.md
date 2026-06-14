# ViewMD 1.0.0 Release Notes Draft

Status: superseded by `docs/RELEASE_NOTES_v1.0.0.md`  
Audience: AI power users on Mac  
Distribution: GitHub Releases
Feedback link: https://github.com/cdraarsh/viewmd/issues/new?template=feedback.yml

## Release Title

ViewMD 1.0.0: Read and export AI-generated Markdown on your Mac

## Short Description

ViewMD turns AI-generated Markdown files into polished Mac documents. Open a `.md` file, read it in a clean PDF-style view, then export a shareable PDF beside the source file.

This is a public beta release. The main request is simple: try ViewMD with one real AI-generated Markdown file and tell us where you got stuck.

## Who This Is For

ViewMD is for Mac users who receive Markdown from AI tools, coding agents, chat exports, research assistants, or automated report generators.

If your AI hands you `report.md`, ViewMD helps you review it and turn it into `report.pdf` without uploading the file or using a browser-based converter.

## What Is Included

- Native macOS app for Markdown files.
- Finder-friendly `.md` and `.markdown` file opening.
- Polished reading view for reports, plans, specs, notes, and research.
- Markdown rendering for headings, lists, tables, links, images, code blocks, and task lists.
- PDF export next to the source file.
- Overwrite confirmation before replacing an existing PDF.
- Local-first workflow. File contents stay on your Mac.

## Install Steps

1. Download `ViewMD-1.0.0-mac-universal-unsigned.zip` from this release.
2. Unzip the file.
3. Move `ViewMD.app` to Applications.
4. Open ViewMD once.
5. Right-click a `.md` file and choose **Open With -> ViewMD**.

To make ViewMD the default app for Markdown files, open Finder's **Get Info** panel for a `.md` file, choose ViewMD under **Open with**, then choose **Change All**.

## Feedback Request

After trying the app, please share:

1. Where your Markdown file came from.
2. Whether you opened your own file.
3. Whether you exported a PDF.
4. The first confusing step or blocker.
5. Whether you would use ViewMD again.

Feedback form: https://github.com/cdraarsh/viewmd/issues/new?template=feedback.yml  
Bug report: https://github.com/cdraarsh/viewmd/issues/new?template=bug_report.yml

## Known Limitations

- ViewMD is not a Markdown editor.
- This first launch is distributed outside the Mac App Store.
- This public beta is unsigned and not notarized. Disclose the macOS warning before download and offer build-from-source instructions.
- Large files may take longer to render or export.
- Some Markdown extensions may not match every AI tool's preview exactly.

## Demo Assets To Attach

- Screenshot 1: AI-generated Markdown report opened in ViewMD.
- Screenshot 2: PDF-style reading view showing a table or code block.
- Screenshot 3: Exported PDF beside the original `.md` file.
- Demo GIF/video: open `.md` -> read -> export PDF.
- Product preview source: `docs/assets/viewmd-feedback-beta-preview.svg`
- Product preview PNG: `docs/assets/viewmd-feedback-beta-preview.png`

## Artifact Checklist

- [ ] `ViewMD-1.0.0-mac-universal-unsigned.zip`
- [ ] Signed app confirmation
- [ ] Notarization decision
- [ ] SHA-256 checksum
- [ ] 3 screenshots
- [ ] 20 to 40 second demo GIF/video
- [x] Beta feedback issue form
- [x] Bug report issue form
