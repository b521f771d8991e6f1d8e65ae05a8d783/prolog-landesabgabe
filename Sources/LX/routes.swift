import LogicKit
import Vapor

func routes(withApp app: Application, andLogicVM lvm: looe.LogicKit.LogicVM) throws {
    // the following methods should be protected by a keycloak access token

    app.get("fetch-law") { req async throws -> String in
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
    }

    app.get("status") { req async throws -> String in
        return "OK"
    }

    app.get("version") { req async throws -> String in
        return "version"  // TODO: fix this error
    }

    app.get("🫖") { req async throws -> String in
        // TODO: magical function that converts this computer into a teapot
        print("Attention! This server is being converted into a teapot 🪄")
        throw Abort(.imATeapot)
    }

    app.get("queryModel") { req async throws -> String in
        guard let query: String = req.query[String.self, at: "query"] else {
            throw Abort(.badRequest, reason: "request requires the parameter query")
        }

        guard let lawName: String = req.query[String.self, at: "law"] else {
            throw Abort(.badRequest, reason: "request requires the parameter law")
        }

        print("Processing query '\(query)' on law '\(lawName)'")

        guard let legalText = fetchLaw(withName: lawName) else {
            throw Abort(.badRequest, reason: "Law \(lawName) not found.")
        }

        return ""
    }

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
