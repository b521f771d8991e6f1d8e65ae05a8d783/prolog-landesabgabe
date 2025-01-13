class ServerConfig {
    getServerProtocol() {
        return "http";
    }

    getServerName() {
        return "localhost";
    }

    getServerPort() {
        return 1337;
    }
}

export const defaultConfig = new ServerConfig();