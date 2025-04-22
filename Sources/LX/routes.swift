import Vapor

private func routesProtected(onApp app: Application) throws {
    // the following methods should be protected by a keycloak access token

    app.get(
        "\(apiPrefix)", "fetch-law",
        use: protectRoute { req async throws -> String in
            guard let kurztitel = req.query[String.self, at: "kurztitel"] else {
                let corpus = fetchCorpus()
                do {
                    let jsonData = try JSONEncoder().encode(corpus)

                    guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                        throw Abort(.internalServerError)
                    }

                    return jsonString
                } catch {
                    throw Abort(.internalServerError)
                }
            }

            if !isAlpha(kurztitel) {
                #if DEBUG
                    print("Possibly malicious request encountered: \(kurztitel)")
                #else
                    print("Logged possible malicious request. Use a debug build to log it")
                #endif
                throw Abort(.notAcceptable)
            }

            guard let law = fetchLaw(withName: kurztitel) else {
                throw Abort(.notFound)
            }

            return law
        })

    app.get(
        "\(apiPrefix)", "🫖",
        use: protectRoute { req async throws -> String in
            // TODO: magical function that converts this computer into a teapot
            print("Attention! This server is being converted into a teapot 🪄")
            throw Abort(.imATeapot)
        })

    app.get(
        "\(apiPrefix)", "queryModel",
        use: protectRoute { req async throws -> String in
            guard let lawName: String = req.query[String.self, at: "law"] else {
                throw Abort(.badRequest, reason: "request requires the parameter 'law'")
            }

            let query = req.query[String.self, at: "query"]
            let javascript = req.query[String.self, at: "js"]

            if query == nil && javascript == nil {
                throw Abort(
                    .badRequest, reason: "request requires the parameter 'query' or 'javascript'")
            }

            print("Processing query '\(query)' on law '\(lawName)'")

            guard let legalText = fetchLaw(withName: lawName) else {
                throw Abort(.badRequest, reason: "Law \(lawName) not found.")
            }

            let pvm = PrologVM()

            if let javascript = javascript {
                try pvm.execute_js(javascript)
            }

            if let query = query {
                try pvm.execute_prolog(query)
            }

            throw Abort(.internalServerError, reason: "unexpected ending of method")
        })
}

private func routesUnprotected(onApp app: Application) throws {
    // the following methods should NOT be protected by KeyCloak

    @Sendable
    func fetchIndexHTML(req: Request) async throws -> Response {
        guard let result = fetchFromWebAppData(withName: "index.html") else {
            throw Abort(.notFound)
        }

        return Response(
            status: .ok,
            headers: ["Content-Type": "text/html"],
            body: .init(stringLiteral: result)
        )
    }

    AppConfig.register(onApp: app)

    app.get("\(apiPrefix)", "status") { req async throws -> String in
        return "OK"
    }

    app.get("\(apiPrefix)", "version") { req async throws -> String in
        return "\(getVersion())"
    }

    app.get("index.html", use: fetchIndexHTML)
    app.get(use: fetchIndexHTML)
    app.get("app", use: fetchIndexHTML)

    app.get("assets", "**") { req async throws -> Response in
        let name = "assets/\(req.parameters.getCatchall().joined(separator: "/"))"

        guard let result = fetchFromWebAppData(withName: name) else {
            throw Abort(.notFound)
        }

        return Response(
            status: .ok, headers: ["Content-Type": guessMimeType(fromPath: name) ?? "text/plain"],
            body: .init(stringLiteral: result))
    }
}

/// Configures the application's routes.
///
/// This function is responsible for setting up the various routes
/// that the application will respond to. Routes define the endpoints
/// and their associated handlers.
///
/// - Parameter app: The `Application` instance to configure routes on.
/// - Throws: An error if route configuration fails.
func routes(onApp app: Application) throws {
    try routesUnprotected(onApp: app)
    try routesProtected(onApp: app)
}
