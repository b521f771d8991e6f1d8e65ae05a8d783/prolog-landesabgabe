import { createBrowserRouter, RouterProvider } from 'react-router-dom';
import { HomePage } from './pages/Home.page';
import { PrologVM } from './model/PrologVM';

export function Router({ prologVM }: { prologVM: PrologVM }) {
  return <RouterProvider router={createBrowserRouter([
    {
      path: '/',
      element: <HomePage prologVM={prologVM} />,
    },
  ])} />;
}
