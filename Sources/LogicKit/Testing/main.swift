import CxxStdlib
import TestingC
// see here https://oleb.net/blog/2017/03/keeping-xctest-in-sync/
// and here: https://www.swift.org/documentation/cxx-interop/
import XCTest

class CTests: XCTestCase {
    static let allTests = [
        ("tests all embedded google tests", test)
    ]

    func test() {
        XCTAssertEqual(looe.LX.TestingC.execute_tests(std.string(CommandLine.arguments[0])), 0)
    }
}

// Swift tests
XCTMain([
    testCase(CTests.allTests)
])
