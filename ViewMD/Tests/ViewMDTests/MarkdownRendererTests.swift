import XCTest
@testable import ViewMD

final class MarkdownRendererTests: XCTestCase {
    let renderer = MarkdownRenderer()

    // MARK: - Basic Elements

    func testHeadingRendering() {
        XCTAssertTrue(renderer.render("# Hello World").contains("<h1>Hello World</h1>"))
        XCTAssertTrue(renderer.render("## Second").contains("<h2>Second</h2>"))
        XCTAssertTrue(renderer.render("### Third").contains("<h3>Third</h3>"))
        XCTAssertTrue(renderer.render("#### Fourth").contains("<h4>Fourth</h4>"))
        XCTAssertTrue(renderer.render("##### Fifth").contains("<h5>Fifth</h5>"))
        XCTAssertTrue(renderer.render("###### Sixth").contains("<h6>Sixth</h6>"))
    }

    func testBoldRendering() {
        let html = renderer.render("This is **bold** text")
        XCTAssertTrue(html.contains("<strong>bold</strong>"))
    }

    func testItalicRendering() {
        let html = renderer.render("This is *italic* text")
        XCTAssertTrue(html.contains("<em>italic</em>"))
    }

    func testStrikethroughRendering() {
        let html = renderer.render("This is ~~deleted~~ text")
        XCTAssertTrue(html.contains("<del>deleted</del>"))
    }

    func testInlineCodeRendering() {
        let html = renderer.render("Use `print()` here")
        XCTAssertTrue(html.contains("<code>print()</code>"))
    }

    func testCodeBlockRendering() {
        let html = renderer.render("```swift\nlet x = 1\n```")
        XCTAssertTrue(html.contains("<pre><code"))
        XCTAssertTrue(html.contains("language-swift"))
        XCTAssertTrue(html.contains("let x = 1"))
    }

    func testCodeBlockNoLanguage() {
        let html = renderer.render("```\nplain code\n```")
        XCTAssertTrue(html.contains("<pre><code>"))
        XCTAssertFalse(html.contains("class=\"language-\""))
    }

    func testMermaidFlowchartCodeBlockRendering() {
        let md = """
        ```mermaid
        flowchart TD
            A --> B
        ```
        """
        let html = renderer.render(md)
        XCTAssertTrue(html.contains("<div class=\"mermaid\">"))
        XCTAssertTrue(html.contains("flowchart TD"))
        XCTAssertTrue(html.contains("A --&gt; B"))
        XCTAssertFalse(html.contains("language-mermaid"))
        XCTAssertFalse(html.contains("<pre><code"))
    }

    func testMermaidLanguageIsCaseInsensitive() {
        let md = """
        ``` Mermaid
        sequenceDiagram
            A->>B: Hello
        ```
        """
        let html = renderer.render(md)
        XCTAssertTrue(html.contains("<div class=\"mermaid\">"))
        XCTAssertFalse(html.contains("language-Mermaid"))
    }

    func testNonMermaidCodeBlockStillRendersAsCode() {
        let html = renderer.render("```javascript\nconst x = '<tag>';\n```")
        XCTAssertTrue(html.contains("<pre><code class=\"language-javascript\">"))
        XCTAssertTrue(html.contains("&lt;tag&gt;"))
        XCTAssertFalse(html.contains("<div class=\"mermaid\">"))
    }

    func testLinkRendering() {
        let html = renderer.render("[Click](https://example.com)")
        XCTAssertTrue(html.contains("<a href=\"https://example.com\">Click</a>"))
    }

    func testImageRendering() {
        let html = renderer.render("![Alt text](image.png)")
        XCTAssertTrue(html.contains("<img src=\"image.png\" alt=\"Alt text\">"))
    }

    func testBlockquoteRendering() {
        let html = renderer.render("> This is a quote")
        XCTAssertTrue(html.contains("<blockquote>"))
        XCTAssertTrue(html.contains("This is a quote"))
    }

    func testHorizontalRule() {
        let html = renderer.render("---")
        XCTAssertTrue(html.contains("<hr>"))
    }

    func testLineBreak() {
        let html = renderer.render("Line one  \nLine two")
        XCTAssertTrue(html.contains("<br>"))
    }

    // MARK: - Lists

    func testUnorderedList() {
        let md = "- Item 1\n- Item 2\n- Item 3"
        let html = renderer.render(md)
        XCTAssertTrue(html.contains("<ul>"))
        XCTAssertTrue(html.contains("<li>Item 1</li>"))
        XCTAssertTrue(html.contains("<li>Item 2</li>"))
        XCTAssertTrue(html.contains("<li>Item 3</li>"))
    }

    func testOrderedList() {
        let md = "1. First\n2. Second\n3. Third"
        let html = renderer.render(md)
        XCTAssertTrue(html.contains("<ol>"))
        XCTAssertTrue(html.contains("<li>First</li>"))
    }

    func testNestedList() {
        let md = "- Outer\n  - Inner\n    - Deep"
        let html = renderer.render(md)
        XCTAssertTrue(html.contains("<ul>"))
        XCTAssertTrue(html.contains("Outer"))
        XCTAssertTrue(html.contains("Inner"))
        XCTAssertTrue(html.contains("Deep"))
    }

    func testTaskList() {
        let md = "- [x] Done\n- [ ] Not done"
        let html = renderer.render(md)
        XCTAssertTrue(html.contains("checked"))
        XCTAssertTrue(html.contains("disabled"))
        XCTAssertTrue(html.contains("Done"))
        XCTAssertTrue(html.contains("Not done"))
    }

    // MARK: - Tables

    func testTableRendering() {
        let md = """
        | A | B |
        |---|---|
        | 1 | 2 |
        """
        let html = renderer.render(md)
        XCTAssertTrue(html.contains("<table>"))
        XCTAssertTrue(html.contains("<thead>"))
        XCTAssertTrue(html.contains("<th>"))
        XCTAssertTrue(html.contains("<tbody>"))
        XCTAssertTrue(html.contains("<td>"))
    }

    func testTableMultipleRows() {
        let md = """
        | Col1 | Col2 | Col3 |
        |------|------|------|
        | a    | b    | c    |
        | d    | e    | f    |
        | g    | h    | i    |
        """
        let html = renderer.render(md)
        let tdCount = html.components(separatedBy: "<td>").count - 1
        XCTAssertEqual(tdCount, 9)
    }

    // MARK: - Edge Cases

    func testEmptyInput() {
        let html = renderer.render("")
        XCTAssertEqual(html, "")
    }

    func testWhitespaceOnlyInput() {
        let html = renderer.render("   \n\n   \n")
        XCTAssertEqual(html.trimmingCharacters(in: .whitespacesAndNewlines), "")
    }

    func testHTMLEscaping() {
        let html = renderer.render("Use `<div>` and `&amp;` in code")
        XCTAssertTrue(html.contains("&lt;div&gt;"))
        XCTAssertTrue(html.contains("&amp;amp;"))
    }

    func testSpecialCharactersInLink() {
        let html = renderer.render("[test](https://example.com/path?a=1&b=2)")
        XCTAssertTrue(html.contains("href=\"https://example.com/path?a=1&amp;b=2\""))
    }

    func testNestedInlineFormatting() {
        let html = renderer.render("***bold and italic***")
        XCTAssertTrue(html.contains("<strong>") || html.contains("<em>"))
    }

    func testConsecutiveCodeBlocks() {
        let md = "```\nblock 1\n```\n\n```\nblock 2\n```"
        let html = renderer.render(md)
        let preCount = html.components(separatedBy: "<pre>").count - 1
        XCTAssertEqual(preCount, 2)
    }

    func testVeryLongLine() {
        let longLine = String(repeating: "word ", count: 1000)
        let html = renderer.render(longLine)
        XCTAssertTrue(html.contains("<p>"))
        XCTAssertTrue(html.count > 5000)
    }

    func testUnicodeContent() {
        let md = "# 日本語テスト\n\nこんにちは世界 🌍\n\n- émojis: 🎉🚀💡"
        let html = renderer.render(md)
        XCTAssertTrue(html.contains("日本語テスト"))
        XCTAssertTrue(html.contains("こんにちは世界"))
        XCTAssertTrue(html.contains("🌍"))
    }

    func testMultipleBlockquotes() {
        let md = "> Quote 1\n\n> Quote 2\n\n> Quote 3"
        let html = renderer.render(md)
        let bqCount = html.components(separatedBy: "<blockquote>").count - 1
        XCTAssertEqual(bqCount, 3)
    }

    func testNestedBlockquote() {
        let md = "> Outer\n> > Inner"
        let html = renderer.render(md)
        XCTAssertTrue(html.contains("<blockquote>"))
        XCTAssertTrue(html.contains("Outer"))
        XCTAssertTrue(html.contains("Inner"))
    }

    func testInlineHTMLPassthrough() {
        let md = "Text with <br> in it"
        let html = renderer.render(md)
        XCTAssertTrue(html.contains("<br>"))
    }

    // MARK: - Full Page Rendering

    func testFullPageRendering() {
        let html = renderer.renderFullPage("# Test")
        XCTAssertTrue(html.contains("<!DOCTYPE html>"))
        XCTAssertTrue(html.contains("<h1>Test</h1>"))
        XCTAssertTrue(html.contains("class=\"page\""))
    }

    func testFullPageContainsCSS() {
        let html = renderer.renderFullPage("Hello")
        XCTAssertTrue(html.contains("font-family"))
        XCTAssertTrue(html.contains("#f1f5f9"))
        XCTAssertTrue(html.contains("Avenir Next"))
        XCTAssertFalse(html.contains("fonts.googleapis.com"))
        XCTAssertFalse(html.contains("fonts.gstatic.com"))
    }

    func testFullPageCanRenderA4PageFormat() {
        let html = MarkdownRenderer(pageFormat: .a4).renderFullPage("Hello")

        XCTAssertTrue(html.contains("size: A4;"))
        XCTAssertTrue(html.contains("max-width: 210mm;"))
        XCTAssertTrue(html.contains("min-height: 297mm;"))
    }

    func testFullPageCanRenderLetterPageFormat() {
        let html = MarkdownRenderer(pageFormat: .usLetter).renderFullPage("Hello")

        XCTAssertTrue(html.contains("size: Letter;"))
        XCTAssertTrue(html.contains("max-width: 8.5in;"))
        XCTAssertTrue(html.contains("min-height: 11in;"))
    }

    func testFullPageColorSchemeForced() {
        let html = renderer.renderFullPage("Hello")
        XCTAssertTrue(html.contains("color-scheme") && html.contains("light"))
    }

    func testFullPageContainsMermaidRuntime() {
        let html = renderer.renderFullPage("```mermaid\nflowchart TD\nA --> B\n```")
        XCTAssertTrue(html.contains("mermaid version"))
        XCTAssertTrue(html.contains("mermaid.initialize"))
        XCTAssertTrue(html.contains("startOnLoad: false"))
        XCTAssertTrue(html.contains("mermaid.run"))
    }

    func testFullPageOmitsMermaidRuntimeWithoutDiagram() {
        let html = renderer.renderFullPage("# Plain Document")
        XCTAssertFalse(html.contains("mermaid version"))
        XCTAssertFalse(html.contains("mermaid.run"))
    }

    func testFullPageEmptyContent() {
        let html = renderer.renderFullPage("")
        XCTAssertTrue(html.contains("<!DOCTYPE html>"))
        XCTAssertTrue(html.contains("class=\"page\""))
    }

    // MARK: - Stress Tests

    func testLargeDocument() {
        var md = ""
        for i in 1...100 {
            md += "## Section \(i)\n\nParagraph content for section \(i). "
            md += "This has **bold**, *italic*, and `code`.\n\n"
            md += "- List item A\n- List item B\n- List item C\n\n"
            md += "```\ncode block \(i)\n```\n\n"
        }
        let html = renderer.render(md)
        XCTAssertTrue(html.contains("Section 1"))
        XCTAssertTrue(html.contains("Section 100"))
        let h2Count = html.components(separatedBy: "<h2>").count - 1
        XCTAssertEqual(h2Count, 100)
    }

    func testLargeDocumentPerformance() {
        var md = ""
        for i in 1...500 {
            md += "## Heading \(i)\n\nLine of text number \(i).\n\n"
        }
        let start = CFAbsoluteTimeGetCurrent()
        let _ = renderer.renderFullPage(md)
        let elapsed = CFAbsoluteTimeGetCurrent() - start
        XCTAssertLessThan(elapsed, 2.0, "Rendering 500 sections should take < 2 seconds")
    }

    func testManyTablesPerformance() {
        var md = ""
        for i in 1...50 {
            md += "| H\(i)A | H\(i)B | H\(i)C |\n|---|---|---|\n"
            for j in 1...10 {
                md += "| r\(j)a | r\(j)b | r\(j)c |\n"
            }
            md += "\n"
        }
        let start = CFAbsoluteTimeGetCurrent()
        let html = renderer.render(md)
        let elapsed = CFAbsoluteTimeGetCurrent() - start
        XCTAssertLessThan(elapsed, 2.0)
        let tableCount = html.components(separatedBy: "<table>").count - 1
        XCTAssertEqual(tableCount, 50)
    }

    func testDeeplyNestedLists() {
        var md = ""
        for i in 0..<10 {
            md += String(repeating: "  ", count: i) + "- Level \(i)\n"
        }
        let html = renderer.render(md)
        XCTAssertTrue(html.contains("Level 0"))
        XCTAssertTrue(html.contains("Level 9"))
    }

    // MARK: - Regression Guards

    func testNoScriptInjection() {
        let md = "Hello <script>alert('xss')</script> world"
        let html = renderer.render(md)
        XCTAssertFalse(html.contains("<script>"))
        XCTAssertFalse(html.contains("</script>"))
        XCTAssertTrue(html.contains("Hello"))
        XCTAssertTrue(html.contains("world"))
    }

    func testImageWithXSSAttempt() {
        let md = "![x](javascript:alert(1))"
        let html = renderer.render(md)
        XCTAssertFalse(html.contains("javascript:"))
        XCTAssertTrue(html.contains("<img"))
        XCTAssertTrue(html.contains("src=\"\""))
    }

    func testLinkWithXSSAttempt() {
        let md = "[click](javascript:alert(1))"
        let html = renderer.render(md)
        XCTAssertFalse(html.contains("javascript:"))
        XCTAssertTrue(html.contains("href=\"\""))
    }

    func testIframeRemoved() {
        let md = "<iframe src=\"evil.com\"></iframe>"
        let html = renderer.render(md)
        XCTAssertFalse(html.contains("<iframe"))
    }

    func testOnEventHandlerRemoved() {
        let md = "<div onmouseover=\"alert(1)\">hover</div>"
        let html = renderer.render(md)
        XCTAssertFalse(html.contains("onmouseover"))
    }

    func testDataURLBlocked() {
        let md = "[click](data:text/html,<script>alert(1)</script>)"
        let html = renderer.render(md)
        XCTAssertFalse(html.contains("data:text/html"))
    }

    func testCodeBlockWithHTMLContent() {
        let md = "```html\n<div class=\"test\">&amp;</div>\n```"
        let html = renderer.render(md)
        XCTAssertTrue(html.contains("&lt;div"))
        XCTAssertTrue(html.contains("&amp;amp;"))
    }

    func testTableWithPipeInContent() {
        let md = "| A | B |\n|---|---|\n| `a|b` | c |"
        let html = renderer.render(md)
        XCTAssertTrue(html.contains("<table>"))
    }
}
