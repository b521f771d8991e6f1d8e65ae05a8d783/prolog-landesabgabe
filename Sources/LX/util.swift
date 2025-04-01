import Assets

@Sendable
func isAlpha(_ str: String) -> Bool {
    return str.range(of: "^[a-zA-Z]+$", options: .regularExpression) != nil
}

@Sendable
func fetchCorpus() -> [String] {
    return ["krog", "labgg"]
    //return looe.lx.assets.list_strings("Corpus").map({ String($0) })
}

@Sendable
func guessMimeType(fromPath path: String) -> String? {
    switch path.pathExtension {
    case "js": "application/javascript"
    case "css": "text/css"
    case "svg": "image/svg+xml"
    case "html": "text/html"
    default: nil
    }
}

@Sendable
func fetchLaw(withName name: String) -> String? {
    let resourceName = std.string("\(name).pl")

    print("Trying to fetch \(resourceName)")

    let resource = String(
        looe.lx.assets.fetch_string(std.string("Corpus"), resourceName))

    if resource != "" {
        return resource
    } else {
        return nil
    }
}

@Sendable
func fetchFromWebAppData(withName path: String) -> String? {
    let resource = String(looe.lx.assets.fetch_string("dist", std.string(path)))

    if resource != "" {
        return resource
    } else {
        return nil
    }
}
