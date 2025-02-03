class ServerConfig {
    getServerProtocol() {
        return `${import.meta.env.VITE_SERVER_PROTOCOL}`;
    }

    getServerName() {
        return `${import.meta.env.VITE_SERVER_HOST}`;
    }

    getServerPort() {
        const serverPortString = import.meta.env.VITE_SERVER_PORT;
        return 1337;
    }
}

export const defaultConfig = new ServerConfig();