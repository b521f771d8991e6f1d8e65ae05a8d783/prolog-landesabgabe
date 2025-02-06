import defaultKeycloak from "@/config/KeycloakConfig";
import Keycloak from "keycloak-js";

export class KeycloakService {
    keycloak: Promise<Keycloak>;

    constructor(keycloak: Keycloak = defaultKeycloak) {
        this.keycloak = new Promise((resolve, reject) => {
            try {
                keycloak.init()
                    .then((authenticated) => {
                        if (!authenticated) {
                            console.log("Not authenticated, please authenticate");
                            keycloak.login();
                            resolve(keycloak);
                        } else {
                            console.log("Already authenticated");
                            resolve(keycloak);
                        }
                    }).catch((err) => {
                        reject(err);
                    });
            } catch (error) {
                console.error('Failed to initialize adapter:', error);
                reject(error);
            }
        });
    }

    async isAuthenticated(): Promise<boolean> {
        const keycloak = await this.getKeycloak();
        return keycloak.authenticated ?? false;
    }

    async getKeycloak(): Promise<Keycloak> {
        return await this.keycloak;
    }
}