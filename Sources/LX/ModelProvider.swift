public struct ModelAnswer: Codable {
}

func queryModel(
    onLaws laws: [String], withJavaScript javascript: String? = nil, andProlog prolog: String? = nil
) throws -> ModelAnswer {

    let pvm = PrologVM()

    if let javascript = javascript {
        try pvm.execute_js(javascript)
    }

    if let query = prolog {
        try pvm.execute_prolog(query)
    }

    return ModelAnswer()
}
