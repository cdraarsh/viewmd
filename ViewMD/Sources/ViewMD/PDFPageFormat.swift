import Foundation

enum PDFPageFormat: Equatable {
    case a4
    case usLetter

    static func preferred(for locale: Locale = .current) -> PDFPageFormat {
        guard let region = locale.region?.identifier.uppercased() else {
            return .a4
        }

        return letterRegions.contains(region) ? .usLetter : .a4
    }

    var cssPageSize: String {
        switch self {
        case .a4:
            return "A4"
        case .usLetter:
            return "Letter"
        }
    }

    var cssWidth: String {
        switch self {
        case .a4:
            return "210mm"
        case .usLetter:
            return "8.5in"
        }
    }

    var cssHeight: String {
        switch self {
        case .a4:
            return "297mm"
        case .usLetter:
            return "11in"
        }
    }

    private static let letterRegions: Set<String> = ["US", "CA", "MX"]
}
