@Sendable
func isAlpha(_ str: String) -> Bool {
    return str.range(of: "^[a-zA-Z]+$", options: .regularExpression) != nil
}

// TODO drop the Assets dependency, write this in pure swift
@Sendable
private func fetchLaws() -> [String] {
    let resources = list_corpus()
    return resources.compactMap { resource in
        let name =
            resource.as_str().toString()
            .replacingOccurrences(of: "Corpus/", with: "")
            .replacingOccurrences(of: ".pl", with: "")
        return name.starts(with: "stdlib/") ? nil : name
    }
}

@Sendable
func fetchCorpus() -> [String] {
    return fetchLaws()
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
    let resourceName = "\(name).pl"

    print("Trying to fetch \(resourceName)")

    if let resource = get_from_corpus(resourceName)?.toString() {
        return resource
    } else {
        return nil
    }
}

@Sendable
func fetchFromWebAppData(withName path: String) -> String? {
    if let resource = get_from_web_app_data(path)?.toString() {
        return resource
    } else {
        return nil
    }
}

@Sendable
func getVersion() -> String {
    let cxxVersion = BuildInformation().get_version().toString()
    return String(cxxVersion)
}
