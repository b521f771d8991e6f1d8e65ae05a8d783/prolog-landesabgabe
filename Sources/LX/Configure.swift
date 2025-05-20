import Vapor

/// Configures the given application instance.
///
/// This function is responsible for setting up the application's
/// configuration, middleware, routes, and other necessary components.
///
/// - Parameter a: The `Application` instance to configure.
func configure(app a: Application) {
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .any([
            "https://innovation-studio.landooe.fivesquare.dev", "https://lx.landooe.fivesquare.dev",
            "http://localhost:4434", "http://localhost:1337",
        ]),
        allowedMethods: [.GET, .POST],
        allowedHeaders: [
            .accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent,
            .accessControlAllowOrigin,
        ]
    )
    let cors = CORSMiddleware(configuration: corsConfiguration)
    // cors-Middleware sollte vor der Standard-Fehler-Middleware mit `at: .beginning` stehen
    app.middleware.use(cors, at: .beginning)
    app.middleware.use(app.sessions.middleware, at: .end)

    app.http.server.configuration.hostname = workerHostname
    app.http.server.configuration.port = workerPort
    app.http.server.configuration.serverName = "LX"
}
