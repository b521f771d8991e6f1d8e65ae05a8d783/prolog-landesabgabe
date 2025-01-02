import { createBrowserRouter, RouterProvider } from 'react-router-dom';
import { HomePage } from './pages/Home.page';
import { AppState } from './model/AppState';

export function Router({ prologVM }: { prologVM: AppState }) {
  return <RouterProvider router={createBrowserRouter([
    {
      path: '/',
      element: <HomePage prologVM={prologVM} />,
    },
  ])} />;
}
