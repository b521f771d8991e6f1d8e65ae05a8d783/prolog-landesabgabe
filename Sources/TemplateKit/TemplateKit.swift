import Foundation
import RegexBuilder

public typealias TextType = String

public struct Placeholder {
    let placeholderName: String
    let pattern: Regex<AnyRegexOutput>

    public init<T>(placeholderIdentifier: String, regex: Regex<T>) {
        self.placeholderName = placeholderIdentifier
        self.pattern = Regex(regex)
    }
}

public enum TemplateElement {
    case text(String)
    case placeholder(Placeholder)

    enum MatchResult: Equatable {
        case noMatch
        case matchFound(Int, [String])

        var offset: Int {
            switch self {
            case .noMatch:
                return 0
            case let .matchFound(i, _):
                return i
            }
        }
    }

    func match(_ input: String) -> MatchResult {
        switch self {
        case let .placeholder(regex):
            if let match = try! regex.pattern.prefixMatch(in: input) {
                let startIndex = input.index(match.range.upperBound, offsetBy: 0)
                return MatchResult.matchFound(
                    startIndex.encodedOffset, match.output.map({ "\($0.value!)" }))
            } else {
                return MatchResult.noMatch
            }
        case let .text(text):
            if input.starts(with: text) {
                let endIndex = text.endIndex
                return MatchResult.matchFound(endIndex.encodedOffset, [])
            } else {
                return MatchResult.noMatch
            }
        }
    }
}

public struct Template {
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

    var identifiers: [String] {
        return self.placeholders.map { $0.placeholderName }
    }

    subscript(identifier: String) -> TextType? {
        get {
            if !self.identifiers.contains(identifier) {
                return nil
            }

            return ""
        }
    }
}
