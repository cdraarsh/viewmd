# Feature Specification: ViewMD — macOS Markdown Viewer

**Feature Branch**: `main`

**Created**: 2026-06-05

**Status**: Draft

**Input**: User description: "A macOS application that registers as the default handler for .md (Markdown) files, renders Markdown with good formatting, shows a PDF-rendered view, and supports single-instance file opening."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Open a Markdown File from Finder (Priority: P1)

A user double-clicks a `.md` file in Finder and the ViewMD application launches (or comes to the foreground if already running) and displays the file's content rendered with rich Markdown formatting.

**Why this priority**: This is the core value proposition — replacing the default text editor experience for Markdown files with a purpose-built viewer.

**Independent Test**: Double-click any `.md` file in Finder; ViewMD opens and renders it with headings, lists, code blocks, links, and images properly formatted.

**Acceptance Scenarios**:

1. **Given** ViewMD is not running and is set as the default `.md` handler, **When** the user double-clicks a `.md` file in Finder, **Then** ViewMD launches and displays the file with full Markdown rendering.
2. **Given** ViewMD is not installed as the default handler, **When** the user right-clicks a `.md` file and selects "Open With > ViewMD", **Then** ViewMD opens and renders the file.
3. **Given** a `.md` file contains headings, bold, italic, links, images, code blocks, and tables, **When** opened in ViewMD, **Then** all elements render correctly with appropriate styling.

---

### User Story 2 - PDF-Rendered View (Priority: P1)

The user sees the Markdown content rendered in a PDF-quality view inside the application — typeset with proper margins, page breaks, and print-ready formatting.

**Why this priority**: The PDF view differentiates this app from basic Markdown previewers, giving users a "finished document" experience without exporting.

**Independent Test**: Open a Markdown file and observe that the PDF-rendered view displays the document with page layout, proper typography, and margins as it would appear when printed or exported to PDF.

**Acceptance Scenarios**:

1. **Given** a Markdown file is open in ViewMD, **When** the user views the document, **Then** the content is displayed in a paginated, PDF-style layout with proper margins and typography.
2. **Given** a long Markdown document is open, **When** the user scrolls, **Then** page boundaries are visually indicated and content flows naturally across pages.

---

### User Story 3 - Single Instance / Multi-File (Priority: P2)

When ViewMD is already running and the user opens another `.md` file from Finder, the file opens in the existing application instance (e.g., as a new tab or window) rather than launching a second copy of the app.

**Why this priority**: Prevents resource waste and window clutter; standard macOS app behavior that users expect.

**Independent Test**: Open one `.md` file to launch ViewMD, then double-click a second `.md` file — it should appear in the same app instance.

**Acceptance Scenarios**:

1. **Given** ViewMD is already running with a file open, **When** the user double-clicks another `.md` file in Finder, **Then** the new file opens in the existing ViewMD instance (new tab or window) and ViewMD comes to the foreground.
2. **Given** ViewMD is already running, **When** multiple `.md` files are selected and opened simultaneously, **Then** all files open in the existing instance.

---

### User Story 4 - Register as Default .md Handler (Priority: P2)

The application registers itself with macOS as a handler for `.md` files so it appears in "Open With" menus and can be set as the default application for Markdown files.

**Why this priority**: Without file association registration, the app cannot fulfill its primary use case of opening files from Finder.

**Independent Test**: After installing ViewMD, right-click any `.md` file in Finder — ViewMD appears in the "Open With" submenu. Setting it as default persists across reboots.

**Acceptance Scenarios**:

1. **Given** ViewMD is installed on macOS, **When** the user right-clicks a `.md` file and selects "Get Info", **Then** ViewMD appears in the "Open with" dropdown list.
2. **Given** the user sets ViewMD as the default app for `.md` files via "Change All" in Get Info, **When** they double-click any `.md` file, **Then** it opens in ViewMD.
3. **Given** ViewMD declares UTI conformance for Markdown files in its Info.plist, **When** the app is first launched, **Then** macOS Launch Services registers it as a capable `.md` handler.

---

### Edge Cases

- What happens when the `.md` file is empty? → The app should display a blank page or a subtle "Empty document" message.
- What happens when the file is extremely large (>10MB)? → The app should still open it without freezing, potentially with lazy rendering.
- What happens when the file contains invalid or broken Markdown syntax? → The app should render it best-effort (graceful degradation), never crash.
- What happens when the file is deleted or moved while open? → The app should show a notification that the file is no longer available.
- What happens when the file is modified externally while open? → The app should detect changes and offer to reload or auto-reload.
- What happens when the file has no `.md` extension but is opened via "Open With"? → The app should still attempt to render it as Markdown.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Application MUST register with macOS Launch Services as a handler for `.md` file types via proper UTI declarations in Info.plist.
- **FR-002**: Application MUST declare conformance to `net.daringfireball.markdown` and `public.plain-text` UTIs.
- **FR-003**: Application MUST handle the `open` Apple Event to receive file paths when launched or activated by Finder.
- **FR-004**: Application MUST render Markdown content with full CommonMark support (headings, lists, emphasis, links, images, code blocks, blockquotes, tables via GFM extension).
- **FR-005**: Application MUST display a PDF-style paginated view of the rendered Markdown with proper margins, page dimensions, and typography.
- **FR-006**: Application MUST enforce single-instance behavior — if already running, new file-open requests MUST be handled by the existing process.
- **FR-007**: Application MUST support opening multiple files simultaneously (as tabs or windows within the single instance).
- **FR-008**: Application MUST run natively on macOS (Apple Silicon and Intel via Universal Binary or platform-specific builds).

### Key Entities

- **Document**: Represents an open Markdown file — has a file path, raw content, parsed AST, and rendered output.
- **Viewer Window/Tab**: The UI container displaying a single Document in the PDF-rendered view.
- **File Association**: The macOS-level registration (Info.plist UTI declarations) that connects `.md` files to the application.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: User can double-click a `.md` file in Finder and see it rendered in ViewMD within 2 seconds of app launch.
- **SC-002**: PDF-rendered view displays correct page layout with margins that match standard US Letter or A4 page dimensions.
- **SC-003**: Opening a second `.md` file while ViewMD is running reuses the existing instance 100% of the time (no duplicate processes).
- **SC-004**: Application appears in Finder's "Open With" menu for `.md` files immediately after first launch.
- **SC-005**: Markdown rendering correctly handles all CommonMark spec elements plus GFM tables and task lists.

## Assumptions

- Target platform is macOS 13 (Ventura) or later.
- The application is a native macOS app (Swift/AppKit or SwiftUI) to properly integrate with Launch Services and Apple Events.
- No export-to-PDF feature is required in v1 — the PDF view is read-only within the app.
- No editing capability is required — this is a viewer only.
- The app will be distributed outside the Mac App Store initially (Developer ID signed or unsigned for local use).
- Internet connectivity is not required — all rendering happens locally.
