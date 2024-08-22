import Foundation
import ActKit

struct TypedIntron: Codable, Equatable {
    typealias MatchFunction = (String) -> Bool

    private static var registeredTypes: Dictionary<String, MatchFunction> = [:]

    static func getIntron(byString str: String) -> MatchFunction? {
        return self.registeredTypes[str]
    }

    static func addIntron(withKey key: String
                          , andMatchFunction fun: @escaping MatchFunction) {
        registeredTypes[key] = fun
    }

    let name: String
    let type: String

    init(withName name: String, andType type: String) {
        self.name = name
        self.type = type
    }

    var toTemplate: String {
        return "${\(name): \(type)}"
    }
}

struct UntypedIntron : Codable, Equatable {
    let name: String

    init(withName name: String) {
        self.name = name
    }

    var toTemplate: String {
        return "${\(name)}"
    }
}

// TODO: parse legal text
// currently, only the other way around is supported:
//          internal represenation -> legal text
enum ASTElement {
    case StringElement(String)
    case IntronPlaceholder
    case Garbage(String)
}

struct AST {
    let elements: [ASTElement]

    public init(withElements elements: [ASTElement]) {
        self.elements = elements
    }

    public init() {
        self.init(withElements: [])
    }

    var isValid: Bool {
        return self.elements.allSatisfy {
            switch($0) {
                case .Garbage(_):
                    return false
                default:
                    return true
            }
         }
    }

    var hasGarbage: Bool {
        return self.elements.contains {
            switch($0) {
                case .Garbage(_):
                    return true
                default:
                    return false
            }
        }
    }
}

public typealias TemplateDict = Dictionary<String, String>;

enum TextElement : Codable, Equatable {
    case text(String)
    case untypedIntron(UntypedIntron)
    case typedIntron(TypedIntron)

    static func ==(lhs: TextElement, rhs: String) -> Bool {
        switch(lhs) {
            case .text(let i):
                return i == rhs
            default:
                return false
        }
    }

    func toTemplate() -> String {
        switch(self) {
            case .text(let i):
                return i
            case .untypedIntron(let uti):
                return uti.toTemplate
            case .typedIntron(let ti):
                return ti.toTemplate
        }
    }

    func toString(withDictionary td: TemplateDict) -> String? {
        switch(self) {
            case .text(let i):
                return i
            case .untypedIntron(let uti):
                return td[uti.name]
            case .typedIntron(let ti):
                return td[ti.name]
        }
    }
}

struct TemplatedString : Codable, Equatable {
    public let content: [TextElement]

    init(withTextElements content: [TextElement]) {
        self.content = content
    }

    init(fromString str: String) {
        var content: [TextElement] = []

        // first Pattern: ${name: type}
        let pattern = try! NSRegularExpression(
            pattern: #"\$\{[A-Za-z:\s]+\}"#
            , options: [])
        let matched = pattern.matches(in: str,
            options: [],
            range: NSRange(location: 0,
                length: str.utf16.count))


        let typedIntronPattern = try! NSRegularExpression(
            pattern: #"\$\{\s*[A-Za-z]+\s*:\s*[A-Za-z]+\s*\}"#
            , options: [])

        let untypedIntronPattern = try! NSRegularExpression(
            pattern: #"\$\{\s*[A-Za-z]+\s*\}"#
            , options: [])

        assert(matched.allSatisfy {$0.numberOfRanges == 1})

        var last = str.startIndex
        for i in matched {
            let contentBefore = str[last ..<
                String.Index(utf16Offset: i.range.location, in: str)]

            if !contentBefore.isEmpty {
                content.append(.text(String(contentBefore)))
            }

            last = String.Index(utf16Offset: i.range.upperBound, in: str)

            let intron = str.substring(with: i.range)

            if typedIntronPattern.matches(in: intron,
                    options: [], range: NSRange(location: 0,
                        length: intron.utf16.count)).count == 1 {
                let withoutParantheses = intron.dropFirst(2).dropLast()
                let results = withoutParantheses.split(separator: ":")

                assert(results.count == 2) // yes this really is a programming error
                                           // since all the other possibilities are wed out above

                let resultsTrimmedAndStringified = results.map { 
                    $0.trimmingCharacters(in: .whitespacesAndNewlines)
                }

                content.append(
                    .typedIntron(
                        TypedIntron(withName: resultsTrimmedAndStringified[0],
                                    andType: resultsTrimmedAndStringified[1])
                        
                    )
                )
            } else if untypedIntronPattern.matches(in: intron,
                    options: [], range: NSRange(location: 0,
                        length: intron.utf16.count)).count == 1 {
                content.append(.untypedIntron(
                    UntypedIntron(withName: intron
                        .dropFirst(2)
                        .dropLast()
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    )
                ))
            } else {
                assert(false)
            }
        }

        self.init(withTextElements: content)
    }

    subscript(_ index: Int) -> TextElement {
        return self.content[index]
    }

    var toTemplate: String {
        return self.content.reduce("") { $0 + $1.toTemplate() }
    }

    public enum ToStringError: Error, Equatable {
        case Unmatched(TextElement)
    }

    func toString(withDictionary td: TemplateDict) -> Swift.Result<String, ToStringError> {
        var ret = ""

        for i in self.content {
            if let res = i.toString(withDictionary: td) {
                ret += res
            } else {
                return .failure(.Unmatched(i))
            }
        }

        return .success(ret)
    }

    static func ==(lhs: TemplatedString, rhs: String) -> Bool {
        // make a TemplateString from rhs in order to normalise
        return lhs.toTemplate == TemplatedString(fromString: rhs).toTemplate
    }
}