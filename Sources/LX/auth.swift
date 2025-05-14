import Foundation
import JWT
import Vapor

/// A structure representing the payload of a JWT (JSON Web Token) for Keycloak authentication.
///
/// This structure conforms to the `JWTPayload` protocol, which defines the requirements for
/// decoding and validating JWT payloads.
///
/// Use this structure to parse and validate the claims contained in a Keycloak-issued JWT.
struct KeycloakPayload: JWTPayload {
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
        case name = "name"
        case emailVerified = "email_verified"
        case preferredUsername = "preferred_username"
        case givenName = "given_name"
        case familyName = "family_name"
        case allowedOrigins = "allowed-origins"
        case realmAccess = "realm_access"
    }

    struct RealmAccess: Codable {
        let roles: [String]
    }

    let name: String
    let emailVerified: Bool
    let preferredUsername: String
    let givenName: String
    let familyName: String
    let expiration: ExpirationClaim
    let subject: SubjectClaim
    let allowedOrigins: [String]
    let realmAccess: RealmAccess

    func verify(using algorithm: some JWTAlgorithm) async throws {
        try self.expiration.verifyNotExpired()

        if lxJwtRole != nil && !realmAccess.roles.contains(lxJwtRole!) {
            throw Abort(.unauthorized, reason: "Unauthorized access: \(lxJwtRole!) not found in \(realmAccess.roles)")
        }
    }
}

/// Sets up the authentication configuration for the application.
///
/// - Parameter _: The application instance on which authentication will be configured.
/// - Note: This function is asynchronous and should be awaited when called.
func setUpAuthentication(onApp _: Application) async throws {
    if let rsaPublicKey = lxJwtRsa256 {
        NSLog("Configured Authentication via RSA 256 (insecure)")
        let key = try Insecure.RSA.PublicKey(pem: rsaPublicKey)
        await app.jwt.keys.add(
            rsa: key,
            digestAlgorithm: .sha256)
    }
}

/// Protects a route by applying authentication and authorization logic.
///
/// - Parameter T: The type of the data or context associated with the route.
/// - Returns: A secured route or response based on the provided logic.
///
/// Use this function to ensure that only authorized users can access specific routes.
func protectRoute<T>(
    _ handler: @escaping (Request) async throws -> T
) -> (Request) async throws -> T {
    return { req in
        try await req.jwt.verify(as: KeycloakPayload.self)
        return try await handler(req)
    }
}
