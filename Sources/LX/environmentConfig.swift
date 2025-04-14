import Foundation

let lxJwtRsa256 = ProcessInfo.processInfo.environment["LX_JWT_RSA_256"]
let lxJwtRole = ProcessInfo.processInfo.environment["LX_JWT_ROLE"]

let workerPortString = ProcessInfo.processInfo.environment["LX_WORKER_LISTEN_PORT"] ?? "1337"
let workerPort = Int(workerPortString) ?? 1337
let workerHostname: String = ProcessInfo.processInfo.environment["LX_WORKER_LISTEN_ON"] ?? "0.0.0.0"

let apiPrefix = ProcessInfo.processInfo.environment["LX_API_PREFIX"] ?? "api"

let lxKeycloakUrl = ProcessInfo.processInfo.environment["LX_KEYCLOAK_URL"]
let lxKeycloakClientId = ProcessInfo.processInfo.environment["LX_KEYCLOAK_CLIENT_ID"]
let lxKeycloakRealm = ProcessInfo.processInfo.environment["LX_KEYCLOAK_REALM"]
