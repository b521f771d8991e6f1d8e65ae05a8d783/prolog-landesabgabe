import Keycloak from "keycloak-js";

const defaultKeycloak = new Keycloak({
    url: import.meta.env.VITE_LX_KEYCLOAK_URL,
    realm: import.meta.env.VITE_LX_KEYCLOAK_REALM,
    clientId: import.meta.env.VITE_LX_KEYCLOAK_CLIENT_ID,
});

export default defaultKeycloak;