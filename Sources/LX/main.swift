import Assets
import Foundation
import LogicKit
import Vapor
import WasmKit

/// Initializes the program root and sets up a jail environment for the application.
/// Prints the current version of the digital law server.
/// Creates and configures an `Application` instance, setting up authentication and routing.
/// Finally, executes the application.
///
/// - Throws: An error if the application fails to initialize, configure, or execute.
looe.lx.assets.init_program_root_and_setup_jail()

print("Running digital law server in version: \(getVersion()) ✨🚀")

let app = try await Application.make(.detect())
try await setUpAuthentication(onApp: app)
configure(app: app)

try routes(onApp: app)
try await app.execute()
