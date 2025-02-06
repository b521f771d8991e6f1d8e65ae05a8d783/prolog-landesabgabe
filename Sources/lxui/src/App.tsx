import '@mantine/core/styles.css';

import { MantineProvider } from '@mantine/core';
import { Router } from './Router';
import { shadcnTheme } from './theme';
import { PrologVM } from './model/PrologVM';


import "./style.css";
import { shadcnCssVariableResolver } from './cssVariableResolver';
import { persister, queryClient } from './util/RestService';
import { PersistQueryClientProvider } from '@tanstack/react-query-persist-client';
import { ReactQueryDevtools } from '@tanstack/react-query-devtools';

export default function App({ prologVM }: { prologVM: PrologVM }) {
  return (
    <MantineProvider
      theme={shadcnTheme}
      cssVariablesResolver={shadcnCssVariableResolver}>
      <PersistQueryClientProvider client={queryClient} persistOptions={{ persister }}>
        <Router prologVM={prologVM} />
        <ReactQueryDevtools initialIsOpen />
      </PersistQueryClientProvider>
    </MantineProvider>
  );
}
