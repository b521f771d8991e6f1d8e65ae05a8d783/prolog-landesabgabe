import Foundation
import LogicKitC

public typealias DataDictionary = Dictionary<String, String>

public struct Obersatz: CustomStringConvertible, Equatable {
    let name: String
    let data: DataDictionary

    public typealias IsApplicableFunction = (Obersatz, Untersatz) -> Schlusssatz
    let isApplicableFun: IsApplicableFunction

    public init(withName name: String,
                andData data: DataDictionary,
                andApplicativeFunction fun: @escaping IsApplicableFunction) {
        self.name = name
        self.data = data
        self.isApplicableFun = fun
    }

    public init(withName name: String,
                andApplicativeFunction fun: @escaping IsApplicableFunction) {
        self.init(withName: name, andData: [:], andApplicativeFunction: fun)
    }

    func isApplicable(u: Untersatz) -> Schlusssatz {
        return self.isApplicableFun(self, u)
    }

    public var description: String {
        return name
    }

    public static func ==(lhs: Obersatz, rhs: Obersatz) -> Bool {
        return lhs.name == rhs.name
    }
}

public struct Untersatz : CustomStringConvertible, Equatable, Codable {
    let name: String
    let data: DataDictionary

    public init(withName name: String,
                andData data: DataDictionary) {
        self.name = name
        self.data = data
    }

    public init(withName name: String) {
        self.init(withName: name, andData: [:])
    }

    public var description: String {
        return name
    }

    public static func ==(lhs: Untersatz, rhs: Untersatz) -> Bool {
        return lhs.name == rhs.name
    }
}

public struct Rechtsfolge: Equatable, Codable {
    let name: String
    let data: Dictionary<String, String>

    init(withName n: String,
         andData d: Dictionary<String, String>) {
        self.name = n
        self.data = d
    }
}

public enum Schlusssatz : Equatable, CustomStringConvertible, Codable {
    case yes
    case no

    public init(withBool b: Bool) {
        if b {
            self = .yes
        } else {
            self = .no
        }
    }

    public func isValid() -> Bool {
        return self == .yes
    }

    public var description: String {
        switch self {
            case .yes:
                return "Schlusssatz(Yes)"
            case .no:
                return "Schlusssatz(No)"
        }
    }
}

public struct UntersatzResult: Equatable, CustomStringConvertible, Codable {
    public let untersatz: Untersatz
    public let schlusssatz: Schlusssatz

    public init(withUntersatz us: Untersatz, andSchlusssatz ss: Schlusssatz) {
        self.untersatz = us
        self.schlusssatz = ss
    }

    public var applicable: Bool {
        return self.schlusssatz == .yes
    }

    public var description: String {
        "UntersatzResult(untersatz: \(untersatz), schlusssatz: \(schlusssatz))"
    }
}

public struct Result: Equatable, CustomStringConvertible {
    public let obersatz: Obersatz
    public let uresult: [UntersatzResult]

    public init(withObersatz os: Obersatz
             , andUntersatzResults rsl: [UntersatzResult]) {
        self.obersatz = os
        self.uresult = rsl
    }

    public var applicable: Bool {
        return uresult.contains { $0.applicable }
    }

    public var applicableUntersätze: [Untersatz] {
        return uresult.filter { $0.applicable }.map { $0.untersatz }
    }

    public var nonApplicableUntersätze: [Untersatz] {
        return uresult.filter { !$0.applicable }.map { $0.untersatz }
    }

    public var description: String {
        return "Result(obersatz: \(obersatz), untersatzresult:\(uresult))"
    }
}

public struct Sachverhalt: Equatable {
    let untersätze: [Untersatz]

    public init(withUntersätze us: [Untersatz]) {
        self.untersätze = us
    }
}

public struct Norm: Equatable {
    let obersätze: [Obersatz]
    let rechtsfolgen: [Rechtsfolge]
    let legalStatement: LegalStatement

    public init(withObersatz os: [Obersatz]
              , andRechtsfolgen rf: [Rechtsfolge]
              , andLegalStatement ls: LegalStatement) {
        self.obersätze = os
        self.rechtsfolgen = rf
        self.legalStatement = ls
    }

    /**
    * matches every Obersatz against every Untersatz in the Sachverhalt,
    * the result is saved in an array
    */
    public func applyNorm(onSachverhalt sv: Sachverhalt) -> [Result] {
        obersätze.map { obersatz in
            Result(withObersatz: obersatz,
            andUntersatzResults: sv.untersätze.map { untersatz in
                UntersatzResult(withUntersatz: untersatz,
                                andSchlusssatz: obersatz.isApplicable(u: untersatz))
            })
        }
    }
    
    public func isApplicable(onSachverhalt sv: Sachverhalt) -> Bool {
        return self.applyNorm(onSachverhalt: sv).allSatisfy { $0.applicable }
    }
}