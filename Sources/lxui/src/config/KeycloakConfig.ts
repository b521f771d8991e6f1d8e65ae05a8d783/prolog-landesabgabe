import Keycloak from "keycloak-js";
import { defaultConfig } from "@/config/ServerConfig";

const defaultKeycloak = new Keycloak({
 url: defaultConfig.getKeycloakURL(),
 realm: "LAND_OOE_SPRACHGURU",
 clientId: import.meta.env.VITE_KEYCLOAK_CLIENT_ID,
});

export default defaultKeycloak;