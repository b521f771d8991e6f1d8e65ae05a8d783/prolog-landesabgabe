import Foundation

public protocol LegalElement: Codable, Equatable {
    var commonName: String { get }
}

typealias LegalElementEnum = Codable & Equatable

public enum PossibleTopLevelMember: LegalElementEnum {
    case text(Text)
    case paragraph(Paragraph)
    case image(Image)
}

public enum PossibleSubelementMembers: LegalElementEnum {
    case text(Text)
    case bullet(Bullet)
    case hyphen(Hyphen)
    case image(Image)
    case code(Code)
    case section(Section)
    case letter(Letter)
    case digit(Digit)
}

public struct Text: LegalElement {
    private var content: String

    public init(_ str: String) {
        self.content = str
    }

    public var commonName: String {
        return "text"
    }
}

public struct Image: LegalElement {
    public var commonName: String {
        return "image"
    }
}

public struct Hyphen: LegalElement {
    public static let identifier: Character = "•"
    public let legalElements: [PossibleSubelementMembers]

    public init(_ elements: [PossibleSubelementMembers]) {
        legalElements = elements
    }

    public var commonName: String {
        return "hyphen"
    }
}

public struct Bullet: LegalElement {
    public static let identifier: Character = "•"
    public let legalElements: [PossibleSubelementMembers]

    public init(withElements elements: [PossibleSubelementMembers]) {
        self.legalElements = elements
    }

    public var commonName: String {
        return "bullet"
    }
}

public struct Letter: LegalElement {
    public let letter: String  // String instead of Character to, frequently, laws can also use syntax like aa, bb, cc
    public let legalElements: [PossibleSubelementMembers]

    public init(withLetter letter: String, andElements elements: [PossibleSubelementMembers]) {
        self.letter = letter
        self.legalElements = elements
    }

    public var commonName: String {
        return "letter"
    }
}

public struct Digit: LegalElement {
    public let digit: UInt16
    public let legalElements: [PossibleSubelementMembers]

    public init(withNumber digit: UInt16, andElements elements: [PossibleSubelementMembers]) {
        self.digit = digit
        self.legalElements = elements
    }

    public var commonName: String {
        return "digit"
    }
}

public struct Section: LegalElement {
    public let number: UInt16
    public let legalElements: [PossibleSubelementMembers]

    public init(withNumber number: UInt16, andElements elements: [PossibleSubelementMembers]) {
        self.number = number
        self.legalElements = elements
    }

    public var commonName: String {
        return "section"
    }
}

public struct Paragraph: LegalElement {
    public let number: UInt16
    public let title: String?
    public let legalElements: [PossibleSubelementMembers]

    public init(
        withNumber number: UInt16, andTitle title: String,
        andElements elements: [PossibleSubelementMembers]
    ) {
        self.number = number
        self.title = title
        self.legalElements = elements
    }

    public init(withNumber number: UInt16, andTitle title: String) {
        self.number = number
        self.title = title
        self.legalElements = []
    }

    public init(withNumber number: UInt16) {
        self.number = number
        self.title = nil
        self.legalElements = []
    }

    public var commonName: String {
        return "paragraph"
    }
}

public struct Act: LegalElement {
    private(set) public var title: String
    private(set) public var dateEnacted: Date
    private(set) public var legalElements: [PossibleTopLevelMember]

    public var commonName: String {
        return "act"
    }

    public var elementCount: Int {
        return legalElements.count
    }

    public init(withTitle title: String, andDate dateEnacted: Date) {
        self.title = title
        self.dateEnacted = dateEnacted
        self.legalElements = []
    }

    public init(
        withTitle title: String, andDate dateEnacted: Date,
        andLegalElements elements: [PossibleTopLevelMember]
    ) {
        self.title = title
        self.dateEnacted = dateEnacted
        self.legalElements = elements
    }

    enum SaveLegalElementError: Error {
        case error
    }

    public func saveToPropertyList(_ filename: String) {
        do {
            let plistData = try PropertyListEncoder().encode(self)
            try plistData.write(to: URL(fileURLWithPath: filename))
        } catch {
            print("Error saving Act to file: \(error)")
        }
    }

    public static func loadFromPropertyList(_ filename: String) -> Act? {
        do {
            let plistData = try Data(contentsOf: URL(fileURLWithPath: filename))
            let act = try PropertyListDecoder().decode(Act.self, from: plistData)
            return act
        } catch {
            print("Error loading Act from file: \(error)")
            return nil
        }
    }

    public func saveToJSON(_ filename: String) {
        do {
            let jsonData = try JSONEncoder().encode(self)
            try jsonData.write(to: URL(fileURLWithPath: filename))
        } catch {
            print("Error saving Act to file: \(error)")
        }
    }

    public static func loadFromJSON(_ filename: String) -> Act? {
        do {
            let plistData = try Data(contentsOf: URL(fileURLWithPath: filename))
            let act = try JSONDecoder().decode(Act.self, from: plistData)
            return act
        } catch {
            print("Error loading Act from file: \(error)")
            return nil
        }
    }

    public mutating func add(legalElement element: PossibleTopLevelMember) {
        legalElements.append(element)
    }

    public mutating func add(legalElements elements: [PossibleTopLevelMember]) {
        legalElements.append(contentsOf: elements)
    }
}
