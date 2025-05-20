import Foundation
import FoundationNetworking
import Vapor

// https://innovation-studio.landooe.fivesquare.dev/auth/realms/LAND_OOE_SPRACHGURU
struct RealmConfig: Codable {
    // {"realm":"LAND_OOE_SPRACHGURU","public_key":"awsfwefwefwef","token-service":"https://innovation-studio.landooe.fivesquare.dev/auth/realms/LAND_OOE_SPRACHGURU/protocol/openid-connect","account-service":"https://innovation-studio.landooe.fivesquare.dev/auth/realms/LAND_OOE_SPRACHGURU/account","tokens-not-before":0}
    let realm: String
    let publicKey: String
    let tokenService: String
    let accountService: String
    let tokensNotBefore: Int

    /// Initializes a RealmConfig by fetching and decoding JSON from the given URL.
    /// Returns nil if the data cannot be loaded or decoded.
    /// - Parameter url: The URL pointing to the JSON configuration.
    init(from url: URL) async throws {
        NSLog("Downloading realm config from: \(url)")
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        self = try decoder.decode(RealmConfig.self, from: data)
    }

    init(fromKeyCloakUrl keycloakServer: URL, keycloakRealm: String) async throws {
        // Construct the URL for the realm config JSON
        let realmConfigUrl =
            keycloakServer
            .appendingPathComponent("realms")
            .appendingPathComponent(keycloakRealm)
        try await self.init(from: realmConfigUrl)
    }

    /// Returns the public key as a PEM-formatted string.
    func getAsPEM() -> String {
        let lineLength = 64
        let header = "-----BEGIN PUBLIC KEY-----"
        let footer = "-----END PUBLIC KEY-----"

        // Remove any whitespace or newlines from the base64 string
        let base64Key = publicKey.replacingOccurrences(
            of: "\\s+", with: "", options: .regularExpression)

        // Split the base64 string into lines of 64 characters
        let lines = stride(from: 0, to: base64Key.count, by: lineLength).map {
            startIndex -> String in
            let start = base64Key.index(base64Key.startIndex, offsetBy: startIndex)
            let end =
                base64Key.index(
                    start,
                    offsetBy: min(
                        lineLength, base64Key.distance(from: start, to: base64Key.endIndex)),
                    limitedBy: base64Key.endIndex) ?? base64Key.endIndex
            return String(base64Key[start..<end])
        }

        return ([header] + lines + [footer]).joined(separator: "\n")
    }

    enum CodingKeys: String, CodingKey {
        case realm
        case publicKey = "public_key"
        case tokenService = "token-service"
        case accountService = "account-service"
        case tokensNotBefore = "tokens-not-before"
    }
}

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
