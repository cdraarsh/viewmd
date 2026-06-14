# ViewMD Test Document

This is a test file for **ViewMD** — a macOS Markdown viewer that renders files as PDF.

## Features

- Rich Markdown rendering
- PDF-style page layout
- Default `.md` file handler
- Single-instance behavior

## Code Example

```swift
struct ContentView: View {
    let document: MarkdownDocument
    
    var body: some View {
        PDFStyleWebView(html: renderedHTML)
    }
}
```

## Table Example

| Feature | Status | Priority |
|---------|--------|----------|
| File Association | Done | P1 |
| PDF Rendering | Done | P1 |
| Single Instance | Done | P2 |
| Dark Mode | Done | P2 |

## Blockquote

> "The best way to predict the future is to invent it."
> — Alan Kay

## Task List

- [x] Create project structure
- [x] Implement Markdown parser
- [x] Build PDF view
- [ ] Add file watching
- [ ] Polish dark mode

---

*Built with ViewMD v1.0.0*
