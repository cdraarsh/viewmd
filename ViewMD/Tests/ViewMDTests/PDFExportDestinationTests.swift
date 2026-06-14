import XCTest
@testable import ViewMD

final class PDFExportDestinationTests: XCTestCase {
    func testPDFDestinationUsesSameFolderAndBasename() {
        let sourceURL = URL(fileURLWithPath: "/Users/aarsh/Documents/notes/report.md")

        let destinationURL = PDFExportDestination.url(for: sourceURL)

        XCTAssertEqual(destinationURL?.path, "/Users/aarsh/Documents/notes/report.pdf")
    }

    func testPDFDestinationReplacesExistingExtension() {
        let sourceURL = URL(fileURLWithPath: "/Users/aarsh/Documents/notes/final.draft.md")

        let destinationURL = PDFExportDestination.url(for: sourceURL)

        XCTAssertEqual(destinationURL?.path, "/Users/aarsh/Documents/notes/final.draft.pdf")
    }

    func testPDFDestinationHandlesMissingSourceURL() {
        let destinationURL = PDFExportDestination.url(for: nil)

        XCTAssertNil(destinationURL)
    }
}
