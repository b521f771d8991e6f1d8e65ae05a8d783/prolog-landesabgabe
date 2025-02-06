import ReactDOM from 'react-dom/client';
import App from './App';

import "./index.css";
import { PrologVM } from './model/PrologVM';
import { KeycloakService } from './services/keycloak/KeycloakService';

const launcher = document.getElementById("launcher")!;

ReactDOM.createRoot(launcher).render(
    <>
        <style>{`          
            .loading-container {
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
                text-align: center;
            }

            .loading-spinner {
                border: 4px solid #333;
                border-top-color: transparent;
                border-radius: 50%;
                width: 50px;
                height: 50px;
                animation: spin 1s linear infinite;
            }

            @keyframes spin {
                from { transform: rotate(0deg); }
                to { transform: rotate(360deg); }
            }

            .loading-text {
                margin-left: 15px;
                font-size: 18px;
                font-family: Arial, sans-serif;
            }
        `}</style>
        <div className={"loading-container"}>
            <div className={"loading-spinner"}></div>
            <div className={"loading-text"}>Loading...</div>
        </div>
    </>
);

const keycloakService = new KeycloakService();

if(await keycloakService.isAuthenticated()) {
    PrologVM.initFromAppState().then((pvm) => {
        launcher.hidden = true;
        ReactDOM.createRoot(document.getElementById('root')!).render(<App prologVM={pvm} />);
    }).catch((x) => {
        console.log(x);
        document.getElementById("root")!.innerHTML = "There was an error while loading the application"
    });
} else {
    console.log("Not authenticated");
}
