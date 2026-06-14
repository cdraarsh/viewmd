# ViewMD Progress and Next Steps

Updated: 2026-06-14
Branch: `main`
Status: In progress

## Current State

ViewMD is implemented as a native SwiftUI macOS document application.

Existing work includes:

- `.md` and Markdown document registration.
- Markdown parsing with Apple's `swift-markdown`.
- HTML generation for headings, lists, tables, links, images, code, and tasks.
- WKWebView-based document display.
- A4-style visual presentation and typography.
- Renderer tests and Markdown fixtures.

The approved product direction is documented in
`docs/PRODUCT_POSITIONING.md`.

## Decisions Made

- Primary audience: non-technical Mac users receiving AI-generated Markdown.
- Primary promise: beautifully read and export AI-generated Markdown.
- V1 remains reader-first.
- V1 includes PDF export because recipients prefer PDF.
- Export defaults beside the source `.md` file.
- Export uses the same basename.
- Existing PDFs require overwrite confirmation.
- Rich-text and raw Markdown editing are deferred.
- The product should be distributed as an understandable Mac application,
  without terminal-based installation.
- Public beta distribution starts with GitHub Releases, supported by the
  product page, README, issue forms, launch copy, and direct outreach.
- The first distribution path is an unsigned public beta for technical Mac and
  AI-builder audiences.
- Broad consumer launch should wait for a Developer ID signed and notarized
  universal app artifact.

## Priority Plan

1. [x] Implement **Export PDF** from the rendered WKWebView.
2. [x] Retain the opened document's source URL for export location selection.
3. [x] Default export to `<source-directory>/<source-basename>.pdf`.
4. [x] Confirm before replacing an existing PDF.
5. Verify A4 and US Letter output; choose a locale-aware default.
6. [x] Test tables, code blocks, task lists, long documents, and local images.
7. [x] Add user-facing copy based on the approved positioning.
8. [x] Add repeatable universal macOS release packaging automation.
9. [x] Add explicit unsigned public beta packaging mode.
10. Test unsigned install, checksum verification, and Apple's per-app Open
    Anyway flow on a clean Mac user account.
11. Produce a Developer ID signed, notarized universal macOS build after paid
    Apple Developer Program access is available.

## Acceptance Criteria

- Double-clicking a `.md` file opens it in ViewMD.
- No file content is uploaded.
- Rendering is visibly more polished than common online previewers.
- Exporting `report.md` defaults to `report.pdf` in the same directory.
- An existing `report.pdf` is not overwritten without confirmation.
- Exported PDFs preserve formatting, tables, code blocks, and images.
- A non-technical user completes the workflow without terminal instructions.

## Open Questions

- Should page size follow locale, or should users choose A4 versus US Letter?
- How should sandbox permissions support exporting beside arbitrary source files?
- Should external links open in the default browser?
- How should local relative images resolve in preview and PDF export?
- Which public-beta blockers must be fixed before paying for Developer ID distribution?

## Resume Point

PDF export, public-beta surfaces, GitHub Pages workflow, and unsigned release
packaging automation are in place. Next rerun should focus on unsigned release
QA, screenshots, and clean-install testing. Recheck `ContentView`,
`PDFStyleWebView`, and `PDFExportDestination` if export behavior changes.
