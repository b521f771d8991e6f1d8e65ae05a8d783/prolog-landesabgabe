import Keycloak from "keycloak-js";

const defaultKeycloak = new Keycloak({
 url: `${import.meta.env.VITE_KEYCLOAK_PROTOCOL}://${import.meta.env.VITE_KEYCLOAK_HOST}:${import.meta.env.VITE_KEYCLOAK_PORT}/auth`,
 realm: import.meta.env.VITE_KEYCLOAK_REALM,
 clientId: import.meta.env.VITE_KEYCLOAK_CLIENT_ID,
});

export default defaultKeycloak;