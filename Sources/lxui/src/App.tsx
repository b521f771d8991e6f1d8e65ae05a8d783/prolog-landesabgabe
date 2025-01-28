import '@mantine/core/styles.css';

import { MantineProvider } from '@mantine/core';
import { Router } from './Router';
import { shadcnTheme } from './theme';
import { PrologVM } from './model/PrologVM';


import "./style.css";
import { shadcnCssVariableResolver } from './cssVariableResolver';

export default function App({ prologVM }: { prologVM: PrologVM }) {
  return (
    <MantineProvider
      theme={shadcnTheme}
      cssVariablesResolver={shadcnCssVariableResolver}>
      <Router prologVM={prologVM} />
    </MantineProvider>
  );
}
