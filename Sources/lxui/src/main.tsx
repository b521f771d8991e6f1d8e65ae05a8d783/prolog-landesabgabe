import ReactDOM from 'react-dom/client';
import App from './App';

// https://mantinehub.com/

import "./index.css";
import { AppState } from './model/AppState';

AppState.initFromLocalStorage().then((pvm) => {
    ReactDOM.createRoot(document.getElementById('root')!)
    .render(<App prologVM={pvm} />);
}).catch((x) => {
    console.log(x);
    document.getElementById("root")!.innerHTML = "There was an error while loading the application"
});

