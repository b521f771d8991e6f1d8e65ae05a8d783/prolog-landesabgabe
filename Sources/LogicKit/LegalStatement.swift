import Foundation

public struct LegalStatement: Codable, Equatable {    
    let ts: TemplatedString
    let textualVariables: TemplateDict

    init(withTemplate ts: TemplatedString,
         andTextualVariables tv: TemplateDict) {
        self.ts = ts
        self.textualVariables = tv
    }

    public init(withTemplateString str: String,
                andTextualVariables tv: TemplateDict) {
        self.init(withTemplate: TemplatedString(fromString: str),
                  andTextualVariables: tv)
    }

    var toString : Swift.Result<String, TemplatedString.ToStringError> {
        return ts.toString(withDictionary: self.textualVariables)
    }
}