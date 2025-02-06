import defaultKeycloak from "@/config/KeycloakConfig";
import Keycloak from "keycloak-js";

export class KeycloakService {
    keycloak: Promise<Keycloak>;
    authenticated: boolean;

    constructor(keycloak: Keycloak = defaultKeycloak) {
        const that = this;
        this.authenticated = true;
        this.keycloak = new Promise(async function() {
            try {
                const authenticated = await keycloak.init();

                if (!authenticated) {
                    keycloak.login();
                } else {
                    that.authenticated = true;
                    return keycloak;
                }
            } catch (error) {
                console.error('Failed to initialize adapter:', error);
            }
        });
    }

    isAuthenticated() {
        return this.authenticated;
    }

    async getKeycloak(): Promise<Keycloak> {
        return await this.keycloak;
    }
}