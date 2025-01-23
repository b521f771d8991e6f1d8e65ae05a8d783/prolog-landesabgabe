import ActKit
import BuildInformation
import Foundation
import LogicKit
import Vapor

let version = String(BuildInformation.getCurrentVersionAsString())

print("Running digital law server in version: \(version) ✨🚀")

public func configure(withApp app: Application, andLogicVM lvm: LogicVM) throws {
    try routes(withApp: app, andLogicVM: lvm)
}

func routes(withApp app: Application, andLogicVM lvm: LogicVM) throws {
    app.get("fetch-law") { req async throws -> String in
        guard let kurztitel: String = req.query[String.self, at: "kurztitel"] else {
            throw Abort(.badRequest)
        }

        let law = fetchLaw(withName: kurztitel)

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

    app.get { req async throws -> String in
        guard let query: String = req.query[String.self, at: "query"] else {
            throw Abort(.badRequest)
        }

        guard let result: String = lvm.process(query: query) else {
            throw Abort(.internalServerError, reason: "error while executing query")
        }

        return result
    }
}

func configure(app a: Application) {
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [
            .accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent,
            .accessControlAllowOrigin,
        ]
    )
    let cors = CORSMiddleware(configuration: corsConfiguration)
    // cors-Middleware sollte vor der Standard-Fehler-Middleware mit `at: .beginning` stehen
    app.middleware.use(cors, at: .beginning)

    app.http.server.configuration.hostname = "worker"
    app.http.server.configuration.port = 1337
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
