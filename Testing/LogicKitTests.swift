import Foundation
@testable import LogicKit
import ActKit
import XCTest

class TestLogicKit: XCTestCase {
    static let allTests = [
        ("testLegalReasoning1", testLegalReasoning1),
        ("testLegalReasoning2", testLegalReasoning2),
        ("testTemplateEngine", testTemplateEngine),
        ("testLandesabgabeAufHolz", testLandesabgabeAufHolz)
    ]

    let untersatz1 = Untersatz(withName: "Untersatz1")
    let untersatz2 = Untersatz(withName: "Untersatz2")
    let untersatz3 = Untersatz(withName: "Untersatz3")

    let obersatz1 = Obersatz(withName: "TestObersatz1") {
    obersatz, untersatz in
        return Schlusssatz(withBool: untersatz.name == "Untersatz1")
    }

    let obersatz2 = Obersatz(withName: "TestObersatz2") {
    obersatz, untersatz in
        return Schlusssatz(withBool: untersatz.name == "Untersatz2")
    }

    let testLS = LegalStatement(withTemplateString: "", andTextualVariables: [:])

    func testLegalReasoning1() {
        let t = Norm(withObersatz: [obersatz1, obersatz2],
                     andRechtsfolgen: [],
                     andLegalStatement: testLS);
        let sv = Sachverhalt(withUntersätze:[untersatz1, untersatz2]);
        
        let result = t.applyNorm(onSachverhalt: sv)
        
        let resultExpected : [Result] = [
            Result(withObersatz: obersatz1, andUntersatzResults:[
                UntersatzResult(withUntersatz: untersatz1,
                            andSchlusssatz: Schlusssatz.yes),
                UntersatzResult(withUntersatz: untersatz2,
                            andSchlusssatz: Schlusssatz.no)
            ]),
            Result(withObersatz: obersatz2, andUntersatzResults:[
                UntersatzResult(withUntersatz: untersatz1,
                            andSchlusssatz: Schlusssatz.no),
                UntersatzResult(withUntersatz: untersatz2,
                            andSchlusssatz: Schlusssatz.yes)
            ])
        ]

        XCTAssert(result == resultExpected)
        XCTAssert(result[0].applicable)
        XCTAssert(result[1].applicable)
        XCTAssert(t.isApplicable(onSachverhalt: sv))
        XCTAssert(result[0].applicableUntersätze == [ untersatz1 ])
        XCTAssert(result[1].applicableUntersätze == [ untersatz2 ])
    }

    func testLegalReasoning2() {
        let t = Norm(withObersatz: [obersatz1, obersatz2],
                    andRechtsfolgen: [],
                    andLegalStatement: testLS);
        let sv = Sachverhalt(withUntersätze: [untersatz1, untersatz3])
        
        let result = t.applyNorm(onSachverhalt: sv)

        let resultExpected: [Result] = [
            Result(withObersatz: obersatz1, andUntersatzResults:[
                UntersatzResult(withUntersatz: untersatz1,
                                andSchlusssatz: Schlusssatz.yes),
                UntersatzResult(withUntersatz: untersatz3,
                                andSchlusssatz: Schlusssatz.no)
            ]),
            Result(withObersatz: obersatz2, andUntersatzResults:[
                UntersatzResult(withUntersatz: untersatz1,
                                andSchlusssatz: Schlusssatz.no),
                UntersatzResult(withUntersatz: untersatz3,
                                andSchlusssatz: Schlusssatz.no)
            ])
        ]

        XCTAssert(result == resultExpected)
        XCTAssert(result[0].applicable)
        XCTAssert(!result[1].applicable)
        XCTAssert(!t.isApplicable(onSachverhalt: sv))
        XCTAssert(result[0].applicableUntersätze == [untersatz1])
        XCTAssert(result[0].nonApplicableUntersätze == [untersatz3])
        XCTAssert(result[1].applicableUntersätze == [])
        XCTAssert(result[1].nonApplicableUntersätze == [untersatz1, untersatz3])
    }

    func testTemplateEngine() {
        let t1 = TemplatedString(fromString: "Das ist ein ${adjektiv} Test. ${test: number}")
        XCTAssert(t1[0] == "Das ist ein ")
        XCTAssert(t1.toTemplate == "Das ist ein ${adjektiv} Test. ${test: number}")
        XCTAssert(t1 == "Das ist ein ${adjektiv } Test. ${ test :  number }")
        XCTAssertEqual(t1.toString(withDictionary: [
            "adjektiv": "kleiner",
            "test": "10"
        ]), .success("Das ist ein kleiner Test. 10"))
    }

    func testLandesabgabeAufHolz() {
        let i = landesAbgabeFactory(withTextualVariables: [
            "object": "Holz",
            "h": "10%",
            "price": "Verkaufspreis"
        ])
        print(i.toString)
        XCTAssertEqual(i.toString, .success(""));
    }
}