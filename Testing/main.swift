// see here https://oleb.net/blog/2017/03/keeping-xctest-in-sync/
// and here: https://www.swift.org/documentation/cxx-interop/
import XCTest
import TestingC
import CxxStdlib

func swift_syslog(withPriority priority : Int32, andMessage message : String, _ args : CVarArg...) {
    withVaList(args) { vsyslog(priority, message, $0) }
}

class CTests: XCTestCase {
    static let allTests = [
        ("tests all embedded google Tests", test)
    ];

    func test() {
        XCTAssertEqual(looe.LX.TestingC.executeTests(std.string(CommandLine.arguments[0])), 0)
    }
}

// Swift tests
XCTMain([
    testCase(CTests.allTests),
    testCase(ActKitTests.allTests),
    testCase(TestLogicKit.allTests)
])