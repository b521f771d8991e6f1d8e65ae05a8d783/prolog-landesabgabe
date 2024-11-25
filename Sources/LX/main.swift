//import ActKit
//import BuildInformation
import Foundation
import Vapor

//import LogicKit

//let version = String(nobs.BuildInformation.getCurrentVersionAsString())
let version = "1.0"

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
        let result: String = "OK \(query)"
        return result
    }
}

let app = Application()
defer { app.shutdown() }
try configure(app)
try app.run()
