import { createBrowserRouter, RouterProvider } from "react-router";
import { VersionString } from "./components/VersionString";
import { HomePage } from "./pages/Home.page";

export function Router() {
	return (
		<RouterProvider
			router={createBrowserRouter([
				{
					path: "/",
					element: <HomePage />,
				},
				{
					path: "/app/version",
					element: (
						<>
							<VersionString successFormat="" prefix="" />
						</>
					),
				},
			])}
		/>
	);
}
