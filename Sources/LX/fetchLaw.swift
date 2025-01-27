func fetchLaw(withName name: String) -> String? {
    let resourceName = "\(name).pl"

    guard let rustResource = fetch_from_corpus(resourceName) else {
        return nil
    }

    let resource = rustResource.toString()
    return resource
}
