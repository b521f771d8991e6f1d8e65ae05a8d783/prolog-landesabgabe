import Foundation

public func landesAbgabeFactory(withTextualVariables tv: Dictionary<String, String>) -> LegalStatement {
    return LegalStatement(withTemplateString: "Das Land erhebt eine "
        + "Landesabgabe auf %{object} idHv %{h: Percentage} des %{price}.",
        andTextualVariables: tv
    )
}