import '@mantine/core/styles.css';

import { useKeycloak } from '@react-keycloak/web';
import { MantineProvider } from '@mantine/core';
import { Router } from './Router';
import { shadcnTheme } from './theme';

import './style.css';

import { ReactQueryDevtools } from '@tanstack/react-query-devtools';
import { PersistQueryClientProvider } from '@tanstack/react-query-persist-client';
import { shadcnCssVariableResolver } from './cssVariableResolver';
import { persister, queryClient } from './util/BackendQueryProvider';

export default function App() {
  const { keycloak, initialized } = useKeycloak();

  if (!initialized) {
    return <div>Loading...</div>;
  }

  if (!keycloak.authenticated) {
    return <div>Not authenticated</div>;
  }

  return (
    <MantineProvider theme={shadcnTheme} cssVariablesResolver={shadcnCssVariableResolver}>
      <PersistQueryClientProvider client={queryClient} persistOptions={{ persister }}>
        <Router />
        <ReactQueryDevtools initialIsOpen />
      </PersistQueryClientProvider>
    </MantineProvider>
  );
}
