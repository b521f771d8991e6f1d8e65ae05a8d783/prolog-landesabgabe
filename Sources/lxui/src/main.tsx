import ReactDOM from 'react-dom/client';
import App from './App';

import "./index.css";
import { PrologVM } from './model/PrologVM';

const pvm = await PrologVM.init();

ReactDOM.createRoot(document.getElementById('root')!)
    .render(<App prologVM={pvm} />);
