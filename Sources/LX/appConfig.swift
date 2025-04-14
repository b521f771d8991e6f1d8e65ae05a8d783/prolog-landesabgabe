import Foundation

struct AppConfig: Codable {
    enum CodingKeys: String, CodingKey {
        case keycloakUrl = "LX_KEYCLOAK_URL"
        case clientId = "LX_KEYCLOAK_CLIENT_ID"
        case keycloakRealm = "LX_KEYCLOAK_REALM"
    }

    init?() {
        if lxKeycloakUrl != nil && lxKeycloakClientId != nil && lxKeycloakRealm != nil {
            self.keycloakUrl = lxKeycloakUrl!
            self.clientId = lxKeycloakClientId!
            self.keycloakRealm = lxKeycloakRealm!
        } else {
            return nil
        }
    }

    let keycloakUrl: String
    let clientId: String
    let keycloakRealm: String
}
