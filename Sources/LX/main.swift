import ActKit
import BuildInformation
import Foundation
import LogicKit
import Vapor

let version = String(BuildInformation.getCurrentVersionAsString())

print("Running digital law server in version: \(version) ✨🚀")

// configures your application
public func configure(withApp app: Application, andLogicVM lvm: LogicVM) throws {
    try routes(withApp: app, andLogicVM: lvm)
}

func routes(withApp app: Application, andLogicVM lvm: LogicVM) throws {
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

        let result: String = lvm.process(query: query)

        return result
    }
}

let lvm = LogicVM()
let app = Application()

defer {
    print("Exiting server ... Goodbye 🌙✨")
    app.shutdown()
}

try configure(withApp: app, andLogicVM: lvm)
try app.run()
