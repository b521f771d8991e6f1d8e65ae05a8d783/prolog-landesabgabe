import defaultKeycloak from "@/config/KeycloakConfig";
import Keycloak from "keycloak-js";

export class KeycloakService {
    keycloak: Promise<Keycloak>;

    constructor(keycloak: Keycloak = defaultKeycloak) {
        this.keycloak = new Promise(async function() {
            try {
                const authenticated = await keycloak.init();

                if (!authenticated) {
                    keycloak.login();
                }

                return keycloak;
            } catch (error) {
                console.error('Failed to initialize adapter:', error);
            }
        });
    }

    isAuthenticated() {
        return true;
    }
}