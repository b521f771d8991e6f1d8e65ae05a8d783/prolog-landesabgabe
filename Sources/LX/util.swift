import Assets
import BuildInformation

@Sendable
func isAlpha(_ str: String) -> Bool {
    return str.range(of: "^[a-zA-Z]+$", options: .regularExpression) != nil
}

// TODO drop the Assets dependency, write this in pure swift
@Sendable
private func fetchLaws() -> [String] {
    let resources = looe.lx.assets.list_strings("Corpus")
    return resources.compactMap { resource in
        let name = String(resource)
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

@Sendable
func getVersion() -> String {
    let cxxVersion = BuildInformation.getCurrentVersionAsString()
    return String(cxxVersion)
}
