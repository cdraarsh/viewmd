# Implementation Plan: ViewMD — macOS Markdown Viewer

**Branch**: `main` | **Date**: 2026-06-05 | **Spec**: `.specify/spec.md`

**Input**: Feature specification from `.specify/spec.md`

## Summary

Build a native macOS document-based application (SwiftUI + AppKit) that registers as the default handler for `.md` files, renders Markdown to HTML via a Swift Markdown parser, and displays it in a PDF-paginated view using WKWebView. The app uses macOS's built-in document architecture to handle file-open events, single-instance behavior, and multi-file support automatically.

## Technical Context

**Language/Version**: Swift 5.9+ / Xcode 15+

**Primary Dependencies**:
- SwiftUI (app lifecycle, window management)
- AppKit (NSDocument architecture for file handling)
- WebKit/WKWebView (HTML/CSS rendering of Markdown in PDF-style layout)
- swift-markdown (Apple's own CommonMark parser, via SPM) or cmark-gfm (C library with GFM support)

**Storage**: N/A (reads files from disk, no persistence)

**Testing**: XCTest (unit tests for Markdown parsing, UI tests for document opening)

**Target Platform**: macOS 13.0+ (Ventura), Universal Binary (Apple Silicon + Intel)

**Project Type**: Desktop application (document-based macOS app)

**Performance Goals**: File open-to-render < 2 seconds, smooth scrolling at 60fps for documents up to 10MB

**Constraints**: Offline-only, no network required, single-instance via macOS document architecture

**Scale/Scope**: Single-purpose viewer app, 1 primary view (PDF-rendered document)

## Architecture

### Document-Based App (Core Pattern)

The app uses **NSDocument subclass** with SwiftUI lifecycle. This gives us:
- Automatic file-open event handling from Finder (no manual Apple Event code needed)
- Single-instance behavior by default (macOS routes open requests to the running instance)
- "Open With" and "Open Recent" menu integration for free
- File change monitoring via NSDocument's built-in mechanisms

### Rendering Pipeline

```
.md file → Read UTF-8 text → Parse with swift-markdown/cmark → Generate HTML string
→ Inject into PDF-style CSS template → Render in WKWebView
```

The PDF view is achieved by:
1. Wrapping rendered HTML in a CSS stylesheet that simulates A4/Letter pages
2. Using `@page` CSS rules with fixed dimensions, margins, and page-break controls
3. Rendering inside a WKWebView which handles pagination, fonts, and layout

### Why WKWebView for PDF View

- Native `PDFView` would require generating an actual PDF document (expensive, complex)
- WKWebView with CSS `@page` rules gives pixel-perfect page simulation with much less code
- Supports syntax highlighting, images, tables out of the box via HTML/CSS
- Smooth scrolling and zoom built-in

## Project Structure

```text
ViewMD/
├── ViewMD.xcodeproj
├── ViewMD/
│   ├── ViewMDApp.swift              # @main App with DocumentGroup
│   ├── MarkdownDocument.swift       # NSDocument subclass — reads .md files
│   ├── ContentView.swift            # Main SwiftUI view hosting the PDF viewer
│   ├── PDFStyleWebView.swift        # WKWebView wrapper (NSViewRepresentable)
│   ├── MarkdownRenderer.swift       # Markdown → HTML conversion
│   ├── Resources/
│   │   ├── pdf-style.css            # CSS for PDF-like page layout
│   │   ├── highlight.css            # Syntax highlighting theme
│   │   └── template.html            # HTML shell for injecting rendered content
│   ├── Info.plist                   # UTI declarations, file associations
│   └── ViewMD.entitlements          # App sandbox entitlements
├── ViewMDTests/
│   ├── MarkdownRendererTests.swift
│   └── DocumentLoadTests.swift
└── Package.swift or SPM dependencies configured in Xcode
```

## Implementation Phases

### Phase 1: App Skeleton + File Association

**Goal**: App launches, registers as `.md` handler, opens files from Finder.

1. **Create Xcode project** as a "Document App" (SwiftUI lifecycle, document-based)
2. **Configure Info.plist** with:
   - `CFBundleDocumentTypes` declaring `.md` and `.markdown` extensions
   - `UTImportedTypeDeclarations` for `net.daringfireball.markdown` UTI
   - Content types: `net.daringfireball.markdown` conforming to `public.plain-text`
3. **Implement `MarkdownDocument`** conforming to `FileDocument` (SwiftUI) or subclassing `NSDocument`:
   - `readableContentTypes` returns markdown UTType
   - `init(configuration:)` reads the file data as UTF-8 string
4. **Wire up `DocumentGroup`** in the App struct so macOS handles open events automatically

**Info.plist — Key Entries**:
```xml
<key>CFBundleDocumentTypes</key>
<array>
  <dict>
    <key>CFBundleTypeName</key>
    <string>Markdown Document</string>
    <key>CFBundleTypeRole</key>
    <string>Viewer</string>
    <key>LSHandlerRank</key>
    <string>Owner</string>
    <key>LSItemContentTypes</key>
    <array>
      <string>net.daringfireball.markdown</string>
    </array>
  </dict>
</array>

<key>UTImportedTypeDeclarations</key>
<array>
  <dict>
    <key>UTTypeIdentifier</key>
    <string>net.daringfireball.markdown</string>
    <key>UTTypeDescription</key>
    <string>Markdown Document</string>
    <key>UTTypeConformsTo</key>
    <array>
      <string>public.plain-text</string>
    </array>
    <key>UTTypeTagSpecification</key>
    <dict>
      <key>public.filename-extension</key>
      <array>
        <string>md</string>
        <string>markdown</string>
        <string>mdown</string>
        <string>mkd</string>
      </array>
    </dict>
  </dict>
</array>
```

### Phase 2: Markdown Rendering

**Goal**: Parse Markdown and produce styled HTML.

1. **Add swift-markdown** (Apple's `swift-markdown` package) via SPM for CommonMark parsing
2. **Implement `MarkdownRenderer`**:
   - Takes raw Markdown string
   - Parses to AST using swift-markdown
   - Walks the AST and emits HTML (or use a built-in HTML visitor)
   - Handles GFM tables, task lists, strikethrough
3. **Create HTML template** (`template.html`) with placeholder for content injection
4. **Create CSS** (`pdf-style.css`) with page-simulation rules

### Phase 3: PDF-Style View

**Goal**: Display rendered HTML in a paginated, PDF-like layout.

1. **Implement `PDFStyleWebView`** as `NSViewRepresentable` wrapping WKWebView
2. **CSS page simulation**:
   ```css
   @media screen {
     .page {
       width: 8.5in;
       min-height: 11in;
       padding: 1in;
       margin: 0.5in auto;
       background: white;
       box-shadow: 0 2px 8px rgba(0,0,0,0.1);
     }
   }
   ```
3. **Wire ContentView** to load the rendered HTML into WKWebView on document open
4. **PDF view is the primary and only document view** — when a file opens, the user immediately sees the PDF-rendered layout

### Phase 4: Polish + Edge Cases

**Goal**: Handle edge cases, file watching, and UX refinements.

1. **File watching**: Use `DispatchSource.makeFileSystemObjectSource` or `NSFilePresenter` to detect external changes and auto-reload
2. **Empty file handling**: Show a centered "Empty document" message
3. **Large file handling**: Load and render asynchronously, show a progress indicator
4. **Window management**: Support Cmd+W to close tabs, Cmd+N disabled (viewer only)
5. **Dark mode**: CSS adapts to system appearance via `@media (prefers-color-scheme: dark)`

## Single-Instance Behavior

macOS document-based apps get single-instance behavior automatically:
- `DocumentGroup` in SwiftUI handles the `open` Apple Event
- When the app is already running and Finder requests a file open, macOS sends the event to the running instance
- The running instance creates a new window/tab for the file
- No custom Apple Event handling or IPC is needed

## Constitution Check

- Single project, no microservices ✓
- No unnecessary abstractions ✓
- Native platform APIs used where possible ✓
- Minimal dependencies (swift-markdown + WebKit, both Apple-provided) ✓

## Verification Plan

1. **Build & Run**: `xcodebuild -scheme ViewMD -configuration Debug build`
2. **File Association Test**: After building, copy the `.app` to `/Applications`, launch once, then check `lsregister -dump | grep ViewMD` to confirm UTI registration
3. **Finder Test**: Double-click a `.md` file → should open in ViewMD with PDF view
4. **Single Instance Test**: With ViewMD running, double-click another `.md` file → opens in same instance
5. **Rendering Test**: Open a file with headings, code blocks, tables, images → all render correctly
6. **Unit Tests**: `xcodebuild test -scheme ViewMD`
