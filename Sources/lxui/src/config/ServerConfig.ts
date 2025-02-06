class ServerConfig {
    getServerProtocol() {
        return `${import.meta.env.VITE_SERVER_PROTOCOL}`;
    }

    getServerName() {
        return `${import.meta.env.VITE_SERVER_HOST}`;
    }

    getServerPort() {
        const serverPortString = import.meta.env.VITE_SERVER_PORT;
        return new Number(serverPortString);
    }

    getKeycloakURL(): string {
        return `${import.meta.env.VITE_KEYCLOAK_PROTOCOL}://${import.meta.env.VITE_KEYCLOAK_HOST}:${import.meta.env.VITE_KEYCLOAK_PORT}/auth`;
    }
}

export const defaultConfig = new ServerConfig();