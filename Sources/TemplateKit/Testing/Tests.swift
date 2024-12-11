import Foundation
import XCTest

@testable import TemplateKit

class TemplateKitTests: XCTestCase {
    static let allTests = [
        ("testTemplateKit", testTemplateKit)
    ]

    func testTemplateKit() {
    }
}

XCTMain([
    testCase(TemplateKitTests.allTests)
])
