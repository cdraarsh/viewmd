# Tasks: ViewMD — macOS Markdown Viewer

**Input**: Design documents from `.specify/plan.md` and `.specify/spec.md`

**Prerequisites**: plan.md (required), spec.md (required)

## Phase 1: Setup (Project Initialization)

**Purpose**: Create Xcode project skeleton and configure build settings

- [ ] T001 Create a new macOS Document App project in Xcode (SwiftUI lifecycle) at `ViewMD/` with bundle identifier `com.viewmd.app`, deployment target macOS 13.0
- [ ] T002 Add `swift-markdown` package dependency via SPM (`https://github.com/apple/swift-markdown.git`, from version 0.4.0)
- [ ] T003 [P] Create project directory structure: `ViewMD/Resources/` for CSS/HTML templates

---

## Phase 2: File Association & Bundle Configuration (Blocking)

**Purpose**: Configure Info.plist so macOS recognizes ViewMD as a `.md` file handler. This MUST be complete before file-open handling works.

**⚠️ CRITICAL**: Without correct bundle configuration, Finder will never route `.md` files to this app.

- [ ] T004 Configure `Info.plist` — add `CFBundleDocumentTypes` array declaring:
  - `CFBundleTypeName`: "Markdown Document"
  - `CFBundleTypeRole`: "Viewer"
  - `LSHandlerRank`: "Owner"
  - `LSItemContentTypes`: `["net.daringfireball.markdown"]`

- [ ] T005 Configure `Info.plist` — add `UTImportedTypeDeclarations` declaring:
  - `UTTypeIdentifier`: `net.daringfireball.markdown`
  - `UTTypeDescription`: "Markdown Document"
  - `UTTypeConformsTo`: `["public.plain-text"]`
  - `UTTypeTagSpecification.public.filename-extension`: `["md", "markdown", "mdown", "mkd"]`

- [ ] T006 Create `MarkdownDocument.swift` — implement `FileDocument` conforming struct:
  - Declare `readableContentTypes` returning `[UTType("net.daringfireball.markdown")!]` with fallback to `.plainText`
  - Implement `init(configuration:)` to read file data as UTF-8 string into a `text` property
  - Implement `fileWrapper(configuration:)` as read-only (throw error or return current content)

- [ ] T007 Configure `ViewMDApp.swift` — set up `DocumentGroup(viewing:)` with `MarkdownDocument` so macOS routes file-open events to this app automatically

**Checkpoint**: After this phase, the app should launch when a `.md` file is double-clicked in Finder (even if it shows raw text). Verify with: build → copy `.app` to `/Applications` → launch once → double-click a `.md` file.

---

## Phase 3: User Story 1 — Open & Render Markdown from Finder (Priority: P1) 🎯 MVP

**Goal**: Double-clicking a `.md` file opens ViewMD and displays the content with rich Markdown formatting.

**Independent Test**: Double-click any `.md` file in Finder → ViewMD opens → content displays with proper headings, bold, code blocks, links, tables.

### Implementation

- [ ] T008 Create `MarkdownRenderer.swift` — implement Markdown-to-HTML conversion:
  - Import `Markdown` (swift-markdown package)
  - Parse raw text using `Document(parsing:)` with options for tables, task lists, strikethrough
  - Walk the AST using `MarkupWalker` or use the built-in `HTMLFormatter` to produce HTML string
  - Return complete HTML string with content wrapped in a `<div class="content">` container

- [ ] T009 [P] Create `ViewMD/Resources/template.html` — HTML shell document:
  - `<!DOCTYPE html>` with `<meta charset="utf-8">`
  - Links to `pdf-style.css` and `highlight.css`
  - Contains a `{{CONTENT}}` placeholder to be replaced with rendered HTML
  - Includes viewport meta tag for proper scaling

- [ ] T010 [P] Create `ViewMD/Resources/pdf-style.css` — base typography and layout:
  - Body: `font-family: -apple-system, BlinkMacSystemFont; line-height: 1.6; color: #1a1a1a`
  - Headings: scaled sizes (h1: 2em, h2: 1.5em, etc.), proper margins
  - Code blocks: `background: #f5f5f5; padding: 1em; border-radius: 6px; overflow-x: auto; font-family: SF Mono, Menlo`
  - Inline code: `background: #f0f0f0; padding: 0.2em 0.4em; border-radius: 3px`
  - Tables: bordered, alternating row colors, padding
  - Blockquotes: left border, italic, muted color
  - Links: blue, underline on hover
  - Images: `max-width: 100%; height: auto`
  - Dark mode support via `@media (prefers-color-scheme: dark)` with inverted colors

- [ ] T011 [P] Create `ViewMD/Resources/highlight.css` — syntax highlighting for code blocks:
  - Use a lightweight theme (e.g., GitHub-style) for keywords, strings, comments, numbers
  - Support common languages: Swift, Python, JavaScript, HTML, CSS, JSON, Shell

- [ ] T012 Create `PDFStyleWebView.swift` — `NSViewRepresentable` wrapping WKWebView:
  - Create and configure `WKWebView` with preferences (JavaScript disabled for security, no navigation)
  - Expose a `loadHTML(_ html: String)` method that calls `webView.loadHTMLString(_:baseURL:)` with the Resources bundle URL as base
  - Set transparent background so the page effect is visible
  - Disable link navigation (override `decidePolicyFor` to cancel external links)

- [ ] T013 Create `ContentView.swift` — main document view:
  - Receives `MarkdownDocument` as `@Binding` or from environment
  - On appear (and when document text changes): call `MarkdownRenderer` to produce HTML, inject into `template.html`, pass to `PDFStyleWebView`
  - Show the `PDFStyleWebView` as the full content of the view
  - Set minimum window size to 700x500

**Checkpoint**: Build and run → open a `.md` file → see fully rendered Markdown in the window. This is the MVP.

---

## Phase 4: User Story 2 — PDF-Rendered View (Priority: P1)

**Goal**: The rendered Markdown displays in a paginated, PDF-style layout with page margins, shadows, and proper print-ready typography.

**Independent Test**: Open a long Markdown document → see distinct page boundaries with shadows, content flowing across pages with proper margins.

### Implementation

- [ ] T014 Update `ViewMD/Resources/pdf-style.css` — add PDF page simulation rules:
  - Add `.page` class: `width: 8.5in; min-height: 11in; padding: 1in; margin: 0.5in auto; background: white; box-shadow: 0 2px 12px rgba(0,0,0,0.08); border-radius: 2px`
  - Body background: `#e8e8e8` (gray canvas behind white pages)
  - Add `@media print` rules with `@page { size: letter; margin: 1in }` for actual PDF export
  - Typography: `font-size: 11pt; line-height: 1.7` for print-appropriate sizing
  - Page break hints: `h1, h2 { page-break-after: avoid }`, `pre, table { page-break-inside: avoid }`

- [ ] T015 Update `ViewMD/Resources/template.html` — add page-wrapping structure:
  - Wrap `{{CONTENT}}` inside `<div class="page">` container
  - Add JavaScript that handles CSS column overflow to simulate multi-page layout (or use CSS `column-fill` / multi-column as page proxy)

- [ ] T016 Update `MarkdownRenderer.swift` — add page-break logic:
  - After producing HTML, optionally insert `<div class="page-break"></div>` before each `<h1>` to simulate page boundaries
  - Or: wrap output so each major section gets its own `.page` div

- [ ] T017 Update `PDFStyleWebView.swift` — configure for PDF-style display:
  - Set WKWebView background to match the gray canvas color
  - Enable smooth scrolling
  - Set initial zoom level appropriate for reading (1.0x or slightly scaled to fit window width)

**Checkpoint**: Open a long `.md` file → see multiple white "pages" on a gray background with proper margins and shadows, content flowing across pages.

---

## Phase 5: User Story 3 — Single Instance / Multi-File (Priority: P2)

**Goal**: Opening another `.md` file while ViewMD is running opens it in the existing instance.

**Independent Test**: Open file A → ViewMD launches. Double-click file B → file B opens in a new window in the same ViewMD process.

### Implementation

- [ ] T018 Verify `DocumentGroup` single-instance behavior works out of the box (SwiftUI document apps handle this automatically via macOS app lifecycle — test and confirm)

- [ ] T019 If needed, configure `ViewMDApp.swift` to support multiple windows:
  - Ensure `DocumentGroup` creates new `Window` for each opened document
  - Add `WindowGroup` configuration if tabbing is desired over separate windows
  - Handle the case where multiple files are opened simultaneously (e.g., select 3 files → Open With → ViewMD)

- [ ] T020 Add window title configuration:
  - Window title shows the filename (e.g., "README.md — ViewMD")
  - Add the file path as subtitle or tooltip

**Checkpoint**: With ViewMD running, double-click a second `.md` file → it opens in the same app instance as a new window. Confirm only one ViewMD process exists via Activity Monitor.

---

## Phase 6: User Story 4 — Register as Default Handler (Priority: P2)

**Goal**: ViewMD appears in Finder's "Open With" menu and can be set as default for `.md` files.

**Independent Test**: Right-click `.md` file → "Open With" → ViewMD is listed. Set as default via Get Info → persists.

### Implementation

- [ ] T021 Verify UTI registration works after first launch:
  - Build the app → copy to `/Applications/`
  - Launch once (triggers Launch Services registration)
  - Run `/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -dump | grep -i viewmd` to confirm registration
  - Right-click a `.md` file → check "Open With" submenu

- [ ] T022 [P] Add app icon:
  - Create `AppIcon` asset in `Assets.xcassets` with appropriate sizes (16, 32, 128, 256, 512, 1024)
  - Icon should visually indicate "Markdown" (e.g., document with "MD" text or Markdown-style formatting marks)

- [ ] T023 [P] Add document icon for `.md` files:
  - Create a document type icon that macOS will show for `.md` files when ViewMD is the default handler
  - Configure in Info.plist under `CFBundleDocumentTypes` → `CFBundleTypeIconFile`

**Checkpoint**: ViewMD appears in "Open With" for `.md` files. Setting it as default via "Change All" in Get Info persists after reopening Finder.

---

## Phase 7: Polish & Edge Cases

**Purpose**: Handle edge cases and UX improvements

- [ ] T024 Implement file-change watching in `MarkdownDocument.swift`:
  - Use `NSFilePresenter` or `DispatchSource.makeFileSystemObjectSource` to detect external modifications
  - Auto-reload the document and re-render when the file changes on disk

- [ ] T025 [P] Handle empty files:
  - In `ContentView.swift`, if document text is empty, show a centered "Empty document" placeholder instead of loading the web view

- [ ] T026 [P] Handle large files gracefully:
  - Add loading state in `ContentView.swift` — show a progress indicator while rendering
  - Render on a background thread, update UI on main thread

- [ ] T027 [P] Add keyboard shortcuts:
  - Cmd+W: Close current window/tab
  - Cmd+O: Open file dialog (filter for `.md` files)
  - Cmd+R: Reload/re-render current document
  - Cmd+Plus/Minus: Zoom in/out (adjust WKWebView magnification)

- [ ] T028 Dark mode support:
  - Ensure `pdf-style.css` dark mode rules activate when macOS is in dark mode
  - Page background becomes dark gray, text becomes light, code blocks adjust

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies — start immediately
- **Phase 2 (File Association)**: Depends on Phase 1 — BLOCKS all user stories
- **Phase 3 (Render)**: Depends on Phase 2 (needs `MarkdownDocument` and `DocumentGroup`)
- **Phase 4 (PDF View)**: Depends on Phase 3 (extends the rendering)
- **Phase 5 (Single Instance)**: Depends on Phase 2 (needs `DocumentGroup` working)
- **Phase 6 (Default Handler)**: Depends on Phase 2 (needs Info.plist configured)
- **Phase 7 (Polish)**: Depends on Phases 3 and 4

### Parallel Opportunities

- T009, T010, T011 can all run in parallel (independent resource files)
- T022, T023 can run in parallel (independent assets)
- T025, T026, T027, T028 can run in parallel (independent edge cases)
- Phase 5 and Phase 6 can run in parallel after Phase 2

### Execution Order (Solo Developer)

1. Phase 1 → Phase 2 → **validate file opens** → Phase 3 → **MVP done**
2. Phase 4 → **PDF view complete**
3. Phase 5 + Phase 6 (quick validation tasks)
4. Phase 7 (polish as time allows)
