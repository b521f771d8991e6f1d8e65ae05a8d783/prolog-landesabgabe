import Vapor

let workerPortString = ProcessInfo.processInfo.environment["WORKER_LISTEN_PORT"] ?? "1337"
let workerPort = Int(workerPortString) ?? 1337
let workerHostname = ProcessInfo.processInfo.environment["WORKER_LISTEN_ON"] ?? "0.0.0.0"

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
