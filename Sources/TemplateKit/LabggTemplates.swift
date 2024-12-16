import Foundation

public protocol PrologFragment {

}

func generateUUID(withID id: String) -> String {
    let uuid = NSUUID().uuidString
    let sanitizedUUID = uuid.replacingOccurrences(of: "-", with: "")
    return "\(id)_\(sanitizedUUID)"
}

public struct LandesabgabeSachverhalt: PrologFragment {
    public let id: String
    static let id_prefix = "sachverhalt"

    init() {
        self.id = generateUUID(withID: (LandesabgabeSachverhalt.id_prefix))
    }
}

public struct LandesabgabePerson: PrologFragment {
    public let id: String
    static let id_prefix = "person"

    init() {
        self.id = generateUUID(withID: (LandesabgabeSachverhalt.id_prefix))
    }
}

public struct LandesabgabeHandlung: PrologFragment {
    public let id: String
    static let id_prefix = "handlung"

    init() {
        self.id = generateUUID(withID: (LandesabgabeSachverhalt.id_prefix))
    }
}

public struct LandesabgabeObjekt: PrologFragment {
    public let id: String
    static let id_prefix = "objekt"

    init() {
        self.id = generateUUID(withID: (LandesabgabeSachverhalt.id_prefix))
    }
}
