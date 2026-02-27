import Foundation

public struct Code : LegalElement {
    public var prologCode: String
    public var prologFileName: String

    public var commonName: String {
        return "code"
    }
}