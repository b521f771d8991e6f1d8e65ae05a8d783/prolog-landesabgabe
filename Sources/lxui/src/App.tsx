import '@mantine/core/styles.css';

import { MantineProvider } from '@mantine/core';
import { Router } from './Router';
import { theme } from './theme';
import { PrologVM } from './model/PrologVM';

export default function App({ prologVM }: { prologVM: PrologVM }) {
  return (
    <MantineProvider theme={theme}>
      <Router prologVM={prologVM} />
    </MantineProvider>
  );
}
