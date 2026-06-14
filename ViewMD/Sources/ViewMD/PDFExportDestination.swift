import Foundation

enum PDFExportDestination {
    static func url(for sourceURL: URL?) -> URL? {
        guard let sourceURL else { return nil }
        return sourceURL.deletingPathExtension().appendingPathExtension("pdf")
    }
}
