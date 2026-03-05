import "@mantine/core/styles.css";

import { MantineProvider } from "@mantine/core";
import { Router } from "./Router";
import { shadcnTheme } from "./theme";

import "./style.css";

import { shadcnCssVariableResolver } from "./cssVariableResolver";

export default function App() {
	return (
		<MantineProvider
			theme={shadcnTheme}
			cssVariablesResolver={shadcnCssVariableResolver}
		>
			<Router />
		</MantineProvider>
	);
}
