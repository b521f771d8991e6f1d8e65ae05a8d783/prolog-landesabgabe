import Assets
//import ActKit
import BuildInformation
import CxxStdlib
import Foundation
import LogicKit
import Vapor

looe.lx.assets.init_program_root_and_setup_jail()

print("Running digital law server in version: \(getVersion()) ✨🚀")

let app = try await Application.make(.detect())
let lvm = looe.LogicKit.LogicVM()
configure(app: app)

try routes(withApp: app, andLogicVM: lvm)
try await app.execute()
