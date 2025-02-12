import ReactDOM from 'react-dom/client';
import App from './App';

import './index.css';

import { ReactKeycloakProvider } from '@react-keycloak/web';
import defaultKeycloak from './config/KeycloakConfig';


ReactDOM.createRoot(document.getElementById('root')!).render(
  <ReactKeycloakProvider authClient={defaultKeycloak} initOptions={{ onLoad: 'login-required' }}>
    <App />
  </ReactKeycloakProvider>
);
