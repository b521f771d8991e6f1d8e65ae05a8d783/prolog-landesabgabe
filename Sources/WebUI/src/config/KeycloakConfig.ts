import { getBaseURL } from "@/util/BackendQueryProvider";
import Keycloak from "keycloak-js";

async function createKeycloakInstance(): Promise<Keycloak | undefined> {
	const response = await fetch(getBaseURL() + "app-config.json");
	const config = await response.json();
	const keycloakNoAuth = "LX_NO_AUTH" in config;
	console.log("Keycloak is disabled: ", keycloakNoAuth);

	return keycloakNoAuth
		? undefined
		: new Keycloak({
				url: config.LX_KEYCLOAK_URL,
				realm: config.LX_KEYCLOAK_REALM,
				clientId: config.LX_KEYCLOAK_CLIENT_ID,
			});
}

const defaultKeycloak = await createKeycloakInstance();

export default defaultKeycloak;
