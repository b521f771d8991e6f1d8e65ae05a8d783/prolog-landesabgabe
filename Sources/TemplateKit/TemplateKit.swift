import Foundation
import RegexBuilder

typealias IdentifierType = String
typealias TextType = String

public class Placeholder {
    let placeholderIdentifier: IdentifierType
    let regex = Regex {
        ""
        Capture {
            OneOrMore(.word)
        }
    }

    init(placeholderIdentifier: IdentifierType) {
        self.placeholderIdentifier = placeholderIdentifier
    }
}

public enum TemplateElement {
    case text(String)
    case placeholder(Placeholder)
}

public struct Template {
    enum MatchResult {
        case match
        case noMatch
    }

    typealias MatchResults = [MatchResult]

    private let parts: [TemplateElement]

    public init(withParts parts: [TemplateElement]) {
        self.parts = parts
    }

    var placeholders: [Placeholder] {
        return parts.compactMap { element in
            if case .placeholder(let placeholder) = element {
                return placeholder
            } else {
                return nil
            }
        }
    }

    var identifiers: [IdentifierType] {
        return self.placeholders.map { $0.placeholderIdentifier }
    }

    func match(withText text: String) -> MatchResults {
        var index = 0
        var matchResults: MatchResults = []

        for i in self.parts {

        }

        return matchResults
    }

    subscript(identifier: IdentifierType) -> TextType? {
        get {
            if !self.identifiers.contains(identifier) {
                return nil
            }

            return ""
        }
    }
}
