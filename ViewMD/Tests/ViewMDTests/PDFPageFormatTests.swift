import Foundation
import XCTest
@testable import ViewMD

final class PDFPageFormatTests: XCTestCase {
    func testUSLocalePrefersLetter() {
        XCTAssertEqual(PDFPageFormat.preferred(for: Locale(identifier: "en_US")), .usLetter)
    }

    func testCanadaLocalePrefersLetter() {
        XCTAssertEqual(PDFPageFormat.preferred(for: Locale(identifier: "en_CA")), .usLetter)
    }

    func testMexicoLocalePrefersLetter() {
        XCTAssertEqual(PDFPageFormat.preferred(for: Locale(identifier: "es_MX")), .usLetter)
    }

    func testNonLetterRegionPrefersA4() {
        XCTAssertEqual(PDFPageFormat.preferred(for: Locale(identifier: "en_GB")), .a4)
    }

    func testA4CSSDimensions() {
        XCTAssertEqual(PDFPageFormat.a4.cssPageSize, "A4")
        XCTAssertEqual(PDFPageFormat.a4.cssWidth, "210mm")
        XCTAssertEqual(PDFPageFormat.a4.cssHeight, "297mm")
    }

    func testLetterCSSDimensions() {
        XCTAssertEqual(PDFPageFormat.usLetter.cssPageSize, "Letter")
        XCTAssertEqual(PDFPageFormat.usLetter.cssWidth, "8.5in")
        XCTAssertEqual(PDFPageFormat.usLetter.cssHeight, "11in")
    }
}
