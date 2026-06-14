import Foundation
import Markdown

struct MarkdownRenderer {
    private let pageFormat: PDFPageFormat

    init(pageFormat: PDFPageFormat = .preferred()) {
        self.pageFormat = pageFormat
    }

    func render(_ markdownText: String) -> String {
        let document = Document(parsing: markdownText, options: [.parseBlockDirectives, .parseSymbolLinks])
        var generator = HTMLGenerator()
        return generator.generateHTML(from: document)
    }

    func renderFullPage(_ markdownText: String) -> String {
        let contentHTML = render(markdownText)
        let template = loadTemplate()
        let script = contentHTML.contains("class=\"mermaid\"") ? mermaidScript() : ""
        return template
            .replacingOccurrences(of: "{{CONTENT}}", with: contentHTML)
            .replacingOccurrences(of: "{{MERMAID_SCRIPT}}", with: script)
            .replacingOccurrences(of: "{{PAGE_SIZE}}", with: pageFormat.cssPageSize)
            .replacingOccurrences(of: "{{PAGE_WIDTH}}", with: pageFormat.cssWidth)
            .replacingOccurrences(of: "{{PAGE_HEIGHT}}", with: pageFormat.cssHeight)
    }

    private func loadTemplate() -> String {
        guard let url = Bundle.module.url(forResource: "template", withExtension: "html"),
              let contents = try? String(contentsOf: url, encoding: .utf8)
        else {
            return """
            <!DOCTYPE html>
            <html><head><meta charset="utf-8">
            <style>@page{size:{{PAGE_SIZE}}}body{font-family:-apple-system,sans-serif;background:#e8e8e8;margin:0;padding:20px}.page{max-width:{{PAGE_WIDTH}};min-height:{{PAGE_HEIGHT}};margin:0 auto;padding:1in;background:white;box-shadow:0 2px 12px rgba(0,0,0,.08)}</style>
            </head><body><div class="page">{{CONTENT}}</div></body></html>
            """
        }
        return contents
    }

    private func mermaidScript() -> String {
        guard let url = Bundle.module.url(forResource: "mermaid.min", withExtension: "js"),
              let runtime = try? String(contentsOf: url, encoding: .utf8)
        else {
            return ""
        }
        let safeRuntime = runtime.replacingOccurrences(of: "</script", with: "<\\/script")
        return """
        <script>
        \(safeRuntime)
        </script>
        <script>
            mermaid.initialize({
                startOnLoad: false,
                theme: 'default',
                securityLevel: 'strict',
                flowchart: {
                    htmlLabels: false,
                    useMaxWidth: true
                }
            });

            window.addEventListener('load', async () => {
                const nodes = document.querySelectorAll('.mermaid');
                if (nodes.length === 0) {
                    return;
                }

                try {
                    await mermaid.run({ nodes });
                } catch (error) {
                    console.error('Mermaid rendering failed', error);
                }
            });
        </script>
        """
    }
}

private struct HTMLGenerator {
    private var output = ""

    mutating func generateHTML(from document: Document) -> String {
        output = ""
        for child in document.children {
            renderBlock(child)
        }
        return output
    }

    private mutating func renderBlock(_ markup: any Markup) {
        switch markup {
        case let heading as Heading:
            let level = heading.level
            output += "<h\(level)>"
            renderInlineChildren(heading)
            output += "</h\(level)>\n"

        case let paragraph as Paragraph:
            output += "<p>"
            renderInlineChildren(paragraph)
            output += "</p>\n"

        case let codeBlock as CodeBlock:
            let lang = codeBlock.language ?? ""
            if lang.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == "mermaid" {
                output += "<div class=\"mermaid\">\(escapeHTML(codeBlock.code))</div>\n"
            } else {
                let langAttr = lang.isEmpty ? "" : " class=\"language-\(escapeAttr(lang))\""
                output += "<pre><code\(langAttr)>\(escapeHTML(codeBlock.code))</code></pre>\n"
            }

        case let blockQuote as BlockQuote:
            output += "<blockquote>\n"
            for child in blockQuote.children { renderBlock(child) }
            output += "</blockquote>\n"

        case let orderedList as OrderedList:
            output += "<ol>\n"
            for child in orderedList.children { renderBlock(child) }
            output += "</ol>\n"

        case let unorderedList as UnorderedList:
            output += "<ul>\n"
            for child in unorderedList.children { renderBlock(child) }
            output += "</ul>\n"

        case let listItem as ListItem:
            if let checkbox = listItem.checkbox {
                let checked = checkbox == .checked ? " checked disabled" : " disabled"
                output += "<li><input type=\"checkbox\"\(checked)> "
            } else {
                output += "<li>"
            }
            let children = Array(listItem.children)
            if children.count == 1, let para = children[0] as? Paragraph {
                renderInlineChildren(para)
            } else {
                for child in children { renderBlock(child) }
            }
            output += "</li>\n"

        case _ as ThematicBreak:
            output += "<hr>\n"

        case let htmlBlock as HTMLBlock:
            output += sanitizeHTML(htmlBlock.rawHTML)

        case let table as Table:
            renderTable(table)

        default:
            for child in markup.children { renderBlock(child) }
        }
    }

    private mutating func renderInlineChildren(_ markup: any Markup) {
        for child in markup.children {
            renderInline(child)
        }
    }

    private mutating func renderInline(_ markup: any Markup) {
        switch markup {
        case let text as Text:
            output += escapeHTML(text.string)

        case let emphasis as Emphasis:
            output += "<em>"
            renderInlineChildren(emphasis)
            output += "</em>"

        case let strong as Strong:
            output += "<strong>"
            renderInlineChildren(strong)
            output += "</strong>"

        case let code as InlineCode:
            output += "<code>\(escapeHTML(code.code))</code>"

        case let link as Link:
            let href = sanitizeURL(link.destination ?? "")
            output += "<a href=\"\(escapeAttr(href))\">"
            renderInlineChildren(link)
            output += "</a>"

        case let image as Image:
            let src = sanitizeURL(image.source ?? "")
            let alt = escapeAttr(image.plainText)
            output += "<img src=\"\(escapeAttr(src))\" alt=\"\(alt)\">"

        case _ as SoftBreak:
            output += "\n"

        case _ as LineBreak:
            output += "<br>\n"

        case let strikethrough as Strikethrough:
            output += "<del>"
            renderInlineChildren(strikethrough)
            output += "</del>"

        case let inlineHTML as InlineHTML:
            output += sanitizeHTML(inlineHTML.rawHTML)

        default:
            renderInlineChildren(markup)
        }
    }

    private mutating func renderTable(_ table: Table) {
        output += "<table>\n<thead>\n<tr>\n"
        let head = table.head
        for cell in head.cells {
            output += "<th>"
            renderInlineChildren(cell)
            output += "</th>\n"
        }
        output += "</tr>\n</thead>\n<tbody>\n"
        for row in table.body.rows {
            output += "<tr>\n"
            for cell in row.cells {
                output += "<td>"
                renderInlineChildren(cell)
                output += "</td>\n"
            }
            output += "</tr>\n"
        }
        output += "</tbody>\n</table>\n"
    }

    private func escapeHTML(_ string: String) -> String {
        string
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
    }

    private func escapeAttr(_ string: String) -> String {
        escapeHTML(string)
    }

    private func sanitizeHTML(_ html: String) -> String {
        var result = html
        let dangerousTags = ["script", "iframe", "object", "embed", "form", "input", "textarea", "button"]
        for tag in dangerousTags {
            let openPattern = "(?i)<\(tag)[^>]*>"
            let closePattern = "(?i)</\(tag)>"
            if let regex = try? NSRegularExpression(pattern: openPattern) {
                result = regex.stringByReplacingMatches(in: result, range: NSRange(result.startIndex..., in: result), withTemplate: "")
            }
            if let regex = try? NSRegularExpression(pattern: closePattern) {
                result = regex.stringByReplacingMatches(in: result, range: NSRange(result.startIndex..., in: result), withTemplate: "")
            }
        }
        let onEventPattern = "(?i)\\s+on\\w+\\s*=\\s*[\"'][^\"']*[\"']"
        if let regex = try? NSRegularExpression(pattern: onEventPattern) {
            result = regex.stringByReplacingMatches(in: result, range: NSRange(result.startIndex..., in: result), withTemplate: "")
        }
        return result
    }

    private func sanitizeURL(_ url: String) -> String {
        let trimmed = url.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if trimmed.hasPrefix("javascript:") || trimmed.hasPrefix("data:text/html") || trimmed.hasPrefix("vbscript:") {
            return ""
        }
        return url
    }
}
