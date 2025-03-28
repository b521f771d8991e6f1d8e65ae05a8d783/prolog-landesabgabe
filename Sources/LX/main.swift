import Assets
//import ActKit
import BuildInformation
import CxxStdlib
import Foundation
import LogicKit
import Vapor

let version = String(BuildInformation.getCurrentVersionAsString())

looe.lx.assets.init_program_root_and_setup_jail()

let workerPortString = ProcessInfo.processInfo.environment["WORKER_LISTEN_PORT"] ?? "1337"

guard let workerPort = Int(workerPortString) else {
    print("WORKER_LISTEN_PORT is not an Int")
    exit(1)
}

let workerHostname = ProcessInfo.processInfo.environment["WORKER_LISTEN_ON"] ?? "0.0.0.0"

let secret =
    ProcessInfo.processInfo.environment["WORKER_KEY"]

print("Running digital law server in version: \(version) ✨🚀")

public func configure(withApp app: Application, andLogicVM lvm: looe.LogicKit.LogicVM) throws {
    try routes(withApp: app, andLogicVM: lvm)
}

@Sendable
func isAlpha(_ str: String) -> Bool {
    return str.range(of: "^[a-zA-Z]+$", options: .regularExpression) != nil
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
func fetchCorpus() -> [String] {
    return ["krog", "labgg"]
    //return looe.lx.assets.list_strings("Corpus").map({ String($0) })
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
func guessMimeType(fromPath path: String) -> String? {
    switch path.pathExtension {
    case "js": "application/javascript"
    case "css": "text/css"
    case "svg": "image/svg+xml"
    case "html": "text/html"
    default: nil
    }
}

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
        return version
    }

    app.get("🫖") { req async throws -> String in
        // TODO: magical function that converts this computer into a teapot
        print("Attention! This server is being converted into a teapot 🪄")
        throw Abort(.imATeapot)
    }

    //app.get("queryModel") { req async throws -> String in
    //    guard let query: String = req.query[String.self, at: "query"] else {
    //        throw Abort(.badRequest)
    //    }
    //
    //    guard let result: String = lvm.process(query: query) else {
    //        throw Abort(.internalServerError, reason: "error while executing query")
    //    }
    //
    //    return result
    //}

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

func configure(app a: Application) {
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .any([
            "https://innovation-studio.landooe.fivesquare.dev", "https://lx.landooe.fivesquare.dev",
            "http://localhost:4434", "http://localhost:1337",
        ]),
        allowedMethods: [.GET, .POST],
        allowedHeaders: [
            .accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent,
            .accessControlAllowOrigin,
        ]
    )
    let cors = CORSMiddleware(configuration: corsConfiguration)
    // cors-Middleware sollte vor der Standard-Fehler-Middleware mit `at: .beginning` stehen
    app.middleware.use(cors, at: .beginning)
    app.middleware.use(app.sessions.middleware, at: .end)

    app.http.server.configuration.hostname = workerHostname
    app.http.server.configuration.port = workerPort
    app.http.server.configuration.serverName = "LX"
}

let app = try await Application.make(.detect())
let lvm = looe.LogicKit.LogicVM()
configure(app: app)

//defer {
//    print("Exiting server ... Goodbye 🌙✨")
//    app.shutdown()
//}

try configure(withApp: app, andLogicVM: lvm)
try await app.execute()
