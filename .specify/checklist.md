# Validation Checklist: ViewMD — Default Handler & PDF Rendering

**Purpose**: Confirm that ViewMD correctly registers as the default `.md` file handler on macOS and renders opened files as a PDF view.
**Created**: 2026-06-05
**Feature**: `.specify/spec.md`

## Pre-Conditions

- [ ] CHK001 ViewMD.app is built successfully (`xcodebuild -scheme ViewMD build` exits 0)
- [ ] CHK002 ViewMD.app is copied to `/Applications/` (required for Launch Services registration)
- [ ] CHK003 ViewMD.app has been launched at least once (triggers UTI registration with macOS)

## Default Application Registration

- [ ] CHK004 Run `lsregister -dump | grep -i viewmd` and confirm output contains `net.daringfireball.markdown` with handler rank "Owner"
- [ ] CHK005 Right-click any `.md` file in Finder → "Open With" submenu lists "ViewMD"
- [ ] CHK006 Right-click any `.md` file → "Get Info" → "Open with" dropdown includes "ViewMD"
- [ ] CHK007 Set ViewMD as default via Get Info → "Change All..." → confirm dialog → close Get Info
- [ ] CHK008 After setting default: double-click a different `.md` file → ViewMD opens (not TextEdit or another app)
- [ ] CHK009 Reboot (or run `killall Finder`) → double-click a `.md` file → still opens in ViewMD (persistence check)
- [ ] CHK010 Open Terminal → run `open test.md` → ViewMD receives the file (CLI invocation works)

## File Open → PDF Rendered View

- [ ] CHK011 Double-click a `.md` file containing headings, paragraphs, and a code block → ViewMD launches and displays content
- [ ] CHK012 The rendered view shows a white "page" on a gray canvas background (PDF-style layout)
- [ ] CHK013 Page dimensions approximate US Letter (8.5" × 11") with ~1" margins on all sides
- [ ] CHK014 Headings render at visually distinct sizes (h1 largest, h2 smaller, etc.)
- [ ] CHK015 Code blocks render in a monospace font with a distinct background color
- [ ] CHK016 Tables render with borders, cell padding, and readable alignment
- [ ] CHK017 Links render in a distinct color (blue or system accent)
- [ ] CHK018 Images render inline with `max-width: 100%` (no horizontal overflow)
- [ ] CHK019 Open a long document (3+ pages of content) → multiple page boundaries are visible with shadows/gaps between pages
- [ ] CHK020 Scrolling through a multi-page document is smooth (no stuttering or blank flashes)

## Single-Instance Routing

- [ ] CHK021 With ViewMD already open showing file A, double-click file B in Finder → file B opens in the same ViewMD process (check Activity Monitor: only 1 "ViewMD" process)
- [ ] CHK022 File B appears in a new window (or tab) — file A remains open and unaffected
- [ ] CHK023 Select 3 `.md` files in Finder → right-click → "Open With > ViewMD" → all 3 open in the single running instance

## Edge Cases

- [ ] CHK024 Double-click an empty `.md` file → app opens without crashing (shows empty page or placeholder)
- [ ] CHK025 Double-click a `.md` file with only invalid/binary content → app opens without crashing (shows best-effort or empty)
- [ ] CHK026 Open a file with `.markdown` extension → ViewMD handles it (not just `.md`)

## Notes

- Check items off as completed: `[x]`
- CHK009 (reboot persistence) can be deferred to final QA if iterating quickly
- If CHK004 fails, the app bundle's Info.plist UTI declarations are misconfigured — revisit T004/T005
- If CHK012–CHK013 fail, the CSS page simulation needs adjustment — revisit T014
- `lsregister` path: `/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister`
