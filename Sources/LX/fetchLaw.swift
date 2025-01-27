func fetchLaw(withName name: String) -> String {
    let resourceName = "\(name).pl"
    let rustResource = fetch_from_corpus(resourceName)
    let resource = rustResource.toString()
    return resource
}
