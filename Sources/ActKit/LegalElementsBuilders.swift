import Foundation

// top level protocol

public protocol PossibleTopMemberProtocol {
    func asPossibleTopLevelMemberMembers() -> [PossibleTopLevelMember]
}

extension Text: PossibleTopMemberProtocol {
    public func asPossibleTopLevelMemberMembers() -> [PossibleTopLevelMember] {
        return [PossibleTopLevelMember.text(self)]
    }
}

extension Paragraph: PossibleTopMemberProtocol {
    public func asPossibleTopLevelMemberMembers() -> [PossibleTopLevelMember] {
        return [PossibleTopLevelMember.paragraph(self)]
    }
}

extension Image: PossibleTopMemberProtocol {    
    public func asPossibleTopLevelMemberMembers() -> [PossibleTopLevelMember] {
        return [PossibleTopLevelMember.image(self)]
    }
}

// subelement protocol

public protocol PossibleSubelementMemberProtocol {
    func asPossibleSubelementMember() -> [PossibleSubelementMembers]
}

extension Text: PossibleSubelementMemberProtocol {
    public func asPossibleSubelementMember() -> [PossibleSubelementMembers] {
        return [.text(self)]
    }
}

extension Bullet: PossibleSubelementMemberProtocol {
    public func asPossibleSubelementMember() -> [PossibleSubelementMembers] {
        return [.bullet(self)]
    }
}

extension Hyphen: PossibleSubelementMemberProtocol {
    public func asPossibleSubelementMember() -> [PossibleSubelementMembers] {
        return [.hyphen(self)]
    }
}

extension Image: PossibleSubelementMemberProtocol {
    public func asPossibleSubelementMember() -> [PossibleSubelementMembers] {
        return [.image(self)]
    }
}

extension Code: PossibleSubelementMemberProtocol {
    public func asPossibleSubelementMember() -> [PossibleSubelementMembers] {
        return [.code(self)]
    }
}

extension Section: PossibleSubelementMemberProtocol {
    public func asPossibleSubelementMember() -> [PossibleSubelementMembers] {
        return [.section(self)]
    }
}

extension Letter: PossibleSubelementMemberProtocol {
    public func asPossibleSubelementMember() -> [PossibleSubelementMembers] {
        return [.letter(self)]
    }
}

extension Digit: PossibleSubelementMemberProtocol {
    public func asPossibleSubelementMember() -> [PossibleSubelementMembers] {
        return [.digit(self)]
    }
}

// Hyphen

@resultBuilder public struct HyphenBuilder {
    public static func buildBlock() -> [any PossibleSubelementMemberProtocol] {
        []
    }

    public static func buildBlock(_ values: any PossibleSubelementMemberProtocol...)
        -> [PossibleSubelementMembers] {
        return values.flatMap { $0.asPossibleSubelementMember() }
    }
}

public func makeHyphen(@HyphenBuilder _ elements: () -> [PossibleSubelementMembers]) -> Hyphen {
    return Hyphen(elements())
}

// Bullet

@resultBuilder public struct BulletBuilder {
    public static func buildBlock() -> [any PossibleSubelementMemberProtocol] {
        []
    }

    public static func buildBlock(_ values: any PossibleSubelementMemberProtocol...)
        -> [PossibleSubelementMembers] {
        return values.flatMap { $0.asPossibleSubelementMember() }
    }
}

public func makeBullet(@BulletBuilder _ elements: () -> [PossibleSubelementMembers])
                      -> Bullet {
    return Bullet(withElements: elements())
}

// Letter

@resultBuilder public struct LetterBuilder {
    public static func buildBlock() -> [any PossibleSubelementMemberProtocol] {
        []
    }

    public static func buildBlock(_ values: any PossibleSubelementMemberProtocol...)
        -> [PossibleSubelementMembers] {
        return values.flatMap { $0.asPossibleSubelementMember() }
    }
}

public func makeLetter(withLetter letter: String
                    , @LetterBuilder _ elements: () -> [PossibleSubelementMembers])
                      -> Letter {
    return Letter(withLetter: letter, andElements: elements())
}

// Digit

@resultBuilder public struct DigitBuilder {
    public static func buildBlock() -> [any PossibleSubelementMemberProtocol] {
        []
    }

    public static func buildBlock(_ values: any PossibleSubelementMemberProtocol...)
        -> [PossibleSubelementMembers] {
        return values.flatMap { $0.asPossibleSubelementMember() }
    }
}

public func makeDigit(number: UInt16
                      , @DigitBuilder _ elements: () -> [PossibleSubelementMembers]) -> Digit {
    return Digit(withNumber: number, andElements: elements())
}

// Section

@resultBuilder public struct SectionBuilder {
    public static func buildBlock() -> [any PossibleSubelementMemberProtocol] {
        []
    }

    public static func buildBlock(_ values: any PossibleSubelementMemberProtocol...)
        -> [PossibleSubelementMembers] {
        return values.flatMap { $0.asPossibleSubelementMember() }
    }
}

public func makeSection(number: UInt16
                      , @SectionBuilder _ elements: () -> [PossibleSubelementMembers]) -> Section {
    return Section(withNumber: number, andElements: elements())
}

// Paragraph

@resultBuilder public struct ParagraphBuilder {
    public static func buildBlock() -> [any PossibleSubelementMemberProtocol] {
        []
    }

    public static func buildBlock(_ values: any PossibleSubelementMemberProtocol...)
        -> [PossibleSubelementMembers] {
        return values.flatMap { $0.asPossibleSubelementMember() }
    }
}

public func makeParagraphWith(number: UInt16
                      , andName name: String
                      , @ParagraphBuilder _ elements: () -> [PossibleSubelementMembers]) -> Paragraph {
    return Paragraph(withNumber: number, andTitle: name, andElements: elements())
}

// Act

@resultBuilder public struct ActBuilder {
    public static func buildBlock() -> [PossibleTopLevelMember] {
        []
    }

    public static func buildBlock(_ values: any PossibleTopMemberProtocol...)
        -> [PossibleTopLevelMember] {
        return values.flatMap { $0.asPossibleTopLevelMemberMembers() }
    }
}

public func makeActWith(name: String
                      , andDateEnacted date: Date
                      , @ActBuilder _ elements: () -> [PossibleTopLevelMember]) -> Act {
    return Act(withTitle: name, andDate: date, andLegalElements: elements())
}