import ActKit
import BuildInformation
import Foundation
import LogicKit
import Vapor

let version = String(BuildInformation.getCurrentVersionAsString())

guard let workerPortString = ProcessInfo.processInfo.environment["WORKER_LISTEN_PORT"] else {
    print("could not get WORKER_LISTEN_PORT")
    exit(1)
}

guard let workerPort = Int(workerPortString) else {
    print("WORKER_LISTEN_PORT is not an Int")
    exit(1)
}

guard let workerHostname = ProcessInfo.processInfo.environment["WORKER_LISTEN_ON"] else {
    print("could not get WORKER_LISTEN_ON")
    exit(1)
}

print("Running digital law server in version: \(version) ✨🚀")

public func configure(withApp app: Application, andLogicVM lvm: LogicVM) throws {
    try routes(withApp: app, andLogicVM: lvm)
}

@Sendable
func isAlpha(_ str: String) -> Bool {
    return str.range(of: "^[a-zA-Z]+$", options: .regularExpression) != nil
}

@Sendable
func fetchLaw(withName name: String) -> String? {
    let resourceName = "\(name).pl"

    guard let rustResource = fetch_from_corpus(resourceName) else {
        return nil
    }

    let resource = rustResource.toString()
    return resource
}

@Sendable
func fetchCorpus() -> [String] {
    return list_corpus().map { $0.as_str().toString() }
}

func routes(withApp app: Application, andLogicVM lvm: LogicVM) throws {
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

    app.get("status") { req async -> String in
        return "OK"
    }

    app.get("version") { req async -> String in
        return version
    }

    app.get("🫖") { req async throws -> String in
        // TODO: magical function that converts this computer into a teapot
        print("Attention! This server is being converted into a teapot 🪄")
        throw Abort(.imATeapot)
    }

    app.get("query") { req async throws -> String in
        guard let query: String = req.query[String.self, at: "query"] else {
            throw Abort(.badRequest)
        }

        guard let result: String = lvm.process(query: query) else {
            throw Abort(.internalServerError, reason: "error while executing query")
        }

        return result
    }

    app.get("index.html") { req async throws -> String in
        return ""
    }

    app.get("app") { req async throws -> String in
        return ""
    }

    app.get("assets") { req async throws -> String in
        return ""
    }
}

func configure(app a: Application) {
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .any([
            "https://innovation-studio.landooe.fivesquare.dev", "https://lx.landooe.fivesquare.dev",
            "http://localhost:4434",
        ]),
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [
            .accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent,
            .accessControlAllowOrigin,
        ]
    )
    let cors = CORSMiddleware(configuration: corsConfiguration)
    // cors-Middleware sollte vor der Standard-Fehler-Middleware mit `at: .beginning` stehen
    app.middleware.use(cors, at: .beginning)

    app.http.server.configuration.hostname = workerHostname
    app.http.server.configuration.port = workerPort
    app.http.server.configuration.serverName = "LX"
}

let lvm = LogicVM()
let app = Application()
configure(app: app)

defer {
    print("Exiting server ... Goodbye 🌙✨")
    app.shutdown()
}

try configure(withApp: app, andLogicVM: lvm)
try app.run()
