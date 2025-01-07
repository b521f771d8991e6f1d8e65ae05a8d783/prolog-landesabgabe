import '@mantine/core/styles.css';

import { MantineProvider } from '@mantine/core';
import { Router } from './Router';
import { shadcnTheme } from './theme';
import { AppState } from './model/AppState';


import "./style.css";
import { shadcnCssVariableResolver } from './cssVariableResolver';

export default function App({ prologVM: appState }: { prologVM: AppState }) {
  return (
    <MantineProvider
      theme={shadcnTheme}
      cssVariablesResolver={shadcnCssVariableResolver}>
      <Router prologVM={appState} />
    </MantineProvider>
  );
}
