import { getBaseURL } from "@/util/BackendQueryProvider";
import Keycloak from "keycloak-js";

async function createKeycloakInstance() {
    const response = await fetch(getBaseURL() + "app-config.json");
    const config = await response.json();
    console.log("Response was", response);

    return new Keycloak({
        url: config.LX_KEYCLOAK_URL,
        realm: config.LX_KEYCLOAK_REALM,
        clientId: config.LX_KEYCLOAK_CLIENT_ID,
    });
}

const defaultKeycloak = await createKeycloakInstance();

export default defaultKeycloak;