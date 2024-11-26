import ActKit
import BuildInformation
import Foundation
import LogicKit
import Vapor

let version = String(BuildInformation.getCurrentVersionAsString())
//let version = ""

print("Running digital law server in version: \(version)")

// configures your application
public func configure(_ app: Application) throws {
    try routes(app)
}

func routes(_ app: Application) throws {
    app.get("status") { req async -> String in
        "OK"
    }

    app.get("version") { req async -> String in
        return version
    }

    app.get { req async throws -> String in
        guard let query: String = req.query[String.self, at: "query"] else {
            throw Abort(.badRequest)
        }

        let result: String = process(query: query)

        return result
    }
}

let app = Application()
defer { app.shutdown() }
try configure(app)
try app.run()
