import '@mantine/core/styles.css';

import { MantineProvider } from '@mantine/core';
import { Router } from './Router';
import { theme } from './theme';
import { AppState } from './model/AppState';

export default function App({ prologVM: appState }: { prologVM: AppState }) {
  return (
    <MantineProvider theme={theme}>
      <Router prologVM={appState} />
    </MantineProvider>
  );
}
