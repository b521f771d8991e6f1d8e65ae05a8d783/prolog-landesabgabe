import { createBrowserRouter, RouterProvider } from 'react-router';
import { HomePage } from './pages/Home.page';
import { PrologVM } from './model/PrologVM';
import { VersionString } from './components/VersionString';

export function Router({ prologVM }: { prologVM: PrologVM }) {
  return <RouterProvider router={createBrowserRouter([
    {
      path: '/',
      element: <HomePage prologVM={prologVM} />,
    },
    {
      path: '/version',
      element: <>
        <VersionString />
      </>
    }
  ])} />;
}
