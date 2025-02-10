import ReactDOM from 'react-dom/client';
import App from './App';

import './index.css';

import { KeycloakService } from './services/keycloak/KeycloakService';
import { ReactKeycloakProvider } from '@react-keycloak/web';
import defaultKeycloak from './config/KeycloakConfig';

//const keycloakService = new KeycloakService();
/*
 * TODO current design decision goes against reactive thinking.
 * => change to KeyCloakProvider wrapping PrologVMProvider wrapping App
 * https://www.geeksforgeeks.org/how-to-implement-keycloak-authentication-in-react/#adding-your-react-app-to-keycloak
 */
//keycloakService
//  .isAuthenticated()
//  .then((isAuthenticated) => {
//    if (isAuthenticated) {
      ReactDOM.createRoot(document.getElementById('root')!).render(
        <ReactKeycloakProvider
          authClient={defaultKeycloak}
          initOptions={{ onLoad: 'login-required' }}
        >
          <App />
        </ReactKeycloakProvider>
      );
//    } else {
//      console.log('Not authenticated');
//    }
//  })
//  .catch((err) => console.log(err));
