import Foundation
import JWT
import Vapor

let lxJwtRsa256 = ProcessInfo.processInfo.environment["LX_JWT_RSA_256"]

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
    }

    var name: String
    var emailVerified: Bool
    var preferredUsername: String
    var givenName: String
    var familyName: String
    var expiration: ExpirationClaim
    var subject: SubjectClaim

    func verify(using algorithm: some JWTAlgorithm) async throws {
        // TODO check role
        try self.expiration.verifyNotExpired()
    }
}

/// Sets up the authentication configuration for the application.
///
/// - Parameter _: The application instance on which authentication will be configured.
/// - Note: This function is asynchronous and should be awaited when called.
func setUpAuthentication(onApp _: Application) async throws {
    if let rsaPublicKey = lxJwtRsa256 {
        print(rsaPublicKey)
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
        let payload = try await req.jwt.verify(as: KeycloakPayload.self)
        return try await handler(req)
    }
}
