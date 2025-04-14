import Foundation
import Vapor

/// A structure that represents the application configuration.
/// Conforms to the `Codable` protocol to support encoding and decoding.
struct AppConfig: Codable {
    enum CodingKeys: String, CodingKey {
        case keycloakUrl = "LX_KEYCLOAK_URL"
        case clientId = "LX_KEYCLOAK_CLIENT_ID"
        case keycloakRealm = "LX_KEYCLOAK_REALM"
    }

    /// Initializes a new instance of the configuration.
    ///
    /// - Returns: An optional instance of the configuration. Returns `nil` if initialization fails.
    init?() {
        if lxKeycloakUrl != nil && lxKeycloakClientId != nil && lxKeycloakRealm != nil {
            self.keycloakUrl = lxKeycloakUrl!
            self.clientId = lxKeycloakClientId!
            self.keycloakRealm = lxKeycloakRealm!
        } else {
            return nil
        }
    }

    /// Registers the application-specific configuration on the provided `Application` instance.
    ///
    /// - Parameter app: The `Application` instance where the configuration will be registered.
    static func register(onApp app: Application) {
        app.get("\(apiPrefix)", "app-config.json") { req async throws -> Response in
            guard let config = AppConfig() else {
                throw Abort(
                    .internalServerError, reason: "Could not construct AppConfig from environment")
            }

            let jsonData = try JSONEncoder().encode(config)
            return Response(
                status: .ok,
                headers: ["Content-Type": "application/json"],
                body: .init(data: jsonData)
            )
        }
    }

    /// The URL for the Keycloak authentication server.
    /// This property is used to configure the connection to the Keycloak server
    /// for authentication and authorization purposes.
    let keycloakUrl: String

    /// The unique identifier for the client, used to distinguish and authenticate the client in the application.
    let clientId: String

    /// The Keycloak realm identifier used for authentication and authorization.
    /// This value specifies the realm within the Keycloak server where the application
    /// is registered and manages user identities.
    let keycloakRealm: String
}
