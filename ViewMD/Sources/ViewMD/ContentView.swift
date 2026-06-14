import SwiftUI
import WebKit

struct ContentView: View {
    let document: MarkdownDocument
    let sourceURL: URL?

    @State private var renderedHTML: String = ""
    @State private var webView: WKWebView?
    @State private var isExporting = false
    @State private var exportErrorMessage: String?

    private let renderer = MarkdownRenderer()

    var body: some View {
        Group {
            if document.text.isEmpty {
                emptyState
            } else {
                PDFStyleWebView(
                    html: renderedHTML,
                    baseURL: sourceDirectoryURL,
                    webView: $webView
                )
            }
        }
        .frame(minWidth: 700, minHeight: 500)
        .preferredColorScheme(.light)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Export PDF", action: exportPDF)
                    .keyboardShortcut("e", modifiers: [.command, .shift])
                    .disabled(!canExportPDF)
            }
        }
        .alert("Export PDF Failed", isPresented: exportErrorIsPresented) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(exportErrorMessage ?? "Unknown error")
        }
        .onAppear { renderDocument() }
        .onChange(of: document.text) { _ in renderDocument() }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            FoldedReaderMark()
                .frame(width: 64, height: 64)
            Text("Empty Document")
                .font(.title2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(nsColor: .windowBackgroundColor))
    }

    private func renderDocument() {
        renderedHTML = renderer.renderFullPage(document.text)
    }

    private var sourceDirectoryURL: URL? {
        sourceURL?.deletingLastPathComponent()
    }

    private var canExportPDF: Bool {
        webView != nil && sourceURL != nil && !document.text.isEmpty && !isExporting
    }

    private var exportErrorIsPresented: Binding<Bool> {
        Binding(
            get: { exportErrorMessage != nil },
            set: { if !$0 { exportErrorMessage = nil } }
        )
    }

    @MainActor
    private func exportPDF() {
        guard let webView else {
            exportErrorMessage = "Markdown view is not ready yet."
            return
        }
        guard let sourceURL else {
            exportErrorMessage = "Missing source file location."
            return
        }

        isExporting = true

        Task { @MainActor in
            defer { isExporting = false }

            do {
                _ = try await PDFExportService().export(webView: webView, sourceURL: sourceURL)
            } catch {
                if let cocoaError = error as? CocoaError, cocoaError.code == .userCancelled {
                    return
                }
                exportErrorMessage = error.localizedDescription
            }
        }
    }
}

private struct FoldedReaderMark: View {
    private let markColor = Color(red: 31.0 / 255.0, green: 81.0 / 255.0, blue: 62.0 / 255.0)

    var body: some View {
        GeometryReader { proxy in
            let width = max(proxy.size.width, 1)
            let height = max(proxy.size.height, 1)
            let scale = min(width, height) / 100
            let lineWidth = max(2.25, 4 * scale)

            ZStack {
                documentPath(in: proxy.size)
                    .stroke(markColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                foldPath(in: proxy.size)
                    .stroke(markColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                readingLinesPath(in: proxy.size)
                    .stroke(markColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .accessibilityLabel("ViewMD Folded Reader logo")
    }

    private func documentPath(in size: CGSize) -> Path {
        Path { path in
            path.move(to: point(30, 14, in: size))
            path.addLine(to: point(58, 14, in: size))
            path.addLine(to: point(76, 32, in: size))
            path.addLine(to: point(76, 86, in: size))
            path.addLine(to: point(30, 86, in: size))
            path.closeSubpath()
        }
    }

    private func foldPath(in size: CGSize) -> Path {
        Path { path in
            path.move(to: point(58, 14, in: size))
            path.addLine(to: point(58, 32, in: size))
            path.addLine(to: point(76, 32, in: size))
        }
    }

    private func readingLinesPath(in size: CGSize) -> Path {
        Path { path in
            path.move(to: point(39, 43, in: size))
            path.addLine(to: point(67, 43, in: size))
            path.move(to: point(39, 55, in: size))
            path.addLine(to: point(67, 55, in: size))
            path.move(to: point(39, 67, in: size))
            path.addLine(to: point(57, 67, in: size))
        }
    }

    private func point(_ x: CGFloat, _ y: CGFloat, in size: CGSize) -> CGPoint {
        let side = min(size.width, size.height)
        let originX = (size.width - side) / 2
        let originY = (size.height - side) / 2

        return CGPoint(
            x: originX + (x / 100) * side,
            y: originY + (y / 100) * side
        )
    }
}

@MainActor
final class PDFExportService {
    private let fileManager: FileManager

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    func export(webView: WKWebView, sourceURL: URL) async throws -> URL {
        let destinationURL = try destinationURL(for: sourceURL)

        if fileManager.fileExists(atPath: destinationURL.path) {
            guard confirmOverwrite(for: destinationURL) else {
                throw CocoaError(.userCancelled)
            }
        }

        let configuration = WKPDFConfiguration()
        let pdfData = try await createPDFData(webView: webView, configuration: configuration)

        do {
            try pdfData.write(to: destinationURL, options: [.atomic])
            return destinationURL
        } catch {
            throw error
        }
    }

    private func destinationURL(for sourceURL: URL) throws -> URL {
        guard let destinationURL = PDFExportDestination.url(for: sourceURL) else {
            throw CocoaError(.fileNoSuchFile)
        }
        return destinationURL
    }

    private func confirmOverwrite(for destinationURL: URL) -> Bool {
        let alert = NSAlert()
        alert.messageText = "Replace Existing PDF?"
        alert.informativeText = "“\(destinationURL.lastPathComponent)” already exists. Replace it?"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Replace")
        alert.addButton(withTitle: "Cancel")
        return alert.runModal() == .alertFirstButtonReturn
    }

    private func createPDFData(webView: WKWebView, configuration: WKPDFConfiguration) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            webView.createPDF(configuration: configuration) { result in
                switch result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
