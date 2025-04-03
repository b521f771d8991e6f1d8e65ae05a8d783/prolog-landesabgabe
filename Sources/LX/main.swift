import Assets
import Foundation
import LogicKit
import Vapor

looe.lx.assets.init_program_root_and_setup_jail()

print("Running digital law server in version: \(getVersion()) ✨🚀")

let app = try await Application.make(.detect())
configure(app: app)

try routes(onApp: app)
try await app.execute()
