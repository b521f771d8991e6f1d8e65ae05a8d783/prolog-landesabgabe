import Foundation
import RegexBuilder
import XCTest

@testable import TemplateKit

class TemplateKitTests: XCTestCase {
    static let allTests = [
        ("testTemplateElementText", testTemplateElementText),
        ("testTemplateElementPlaceholder", testTemplateElementPlaceholder),
        ("testTemplateEngine", testTemplateEngine),
    ]

    func testTemplateElementText() {
        let t1 = TemplateElement.text("test")
        XCTAssertEqual(t1.match("test").offset, 4)
        XCTAssertEqual(t1.match("te").offset, 0)
        XCTAssertEqual(t1.match("testtest").offset, 4)

        let t2 = TemplateElement.text("te")
        XCTAssertEqual(t2.match("test").offset, 2)
        XCTAssertEqual(t2.match("te").offset, 2)
        XCTAssertEqual(t2.match("testtest").offset, 2)

        let t3 = TemplateElement.text("💥")
        XCTAssertEqual(t3.match("test").offset, 0)
        XCTAssertEqual(t3.match("te").offset, 0)
        XCTAssertEqual(t3.match("testtest").offset, 0)
    }

    func testTemplateElementPlaceholder() {
        let m1 = TemplateElement.placeholder(
            Placeholder(
                placeholderIdentifier: "digits",
                regex: Regex {
                    "{"
                    OneOrMore(.digit)
                    "}"
                }
            )
        )

        XCTAssertEqual(m1.match("aaa{0001}aaa"), .noMatch)
        XCTAssertEqual(m1.match("{0001}aaa"), .matchFound(6, ["{0001}"]))
        XCTAssertEqual(m1.match("{0001}{0001}"), .matchFound(6, ["{0001}"]))
    }

    func testTemplateEngine() {
        let templateElement = TemplateElement.placeholder(
            Placeholder(
                placeholderIdentifier: "digits",
                regex: Regex {
                    "{"
                    OneOrMore(.digit)
                    "}"
                }
            )
        )

        let templateEngine = TemplateEngine(
            withParts: [TemplateElement.text("aa"), templateElement, templateElement],
            andText: "aa{0001}{0001}"
        )

        XCTAssertEqual(
            templateEngine.matches,
            [.matchFound(2, []), .matchFound(6, ["{0001}"]), .matchFound(6, ["{0001}"])])
    }
}

XCTMain([
    testCase(TemplateKitTests.allTests)
])
