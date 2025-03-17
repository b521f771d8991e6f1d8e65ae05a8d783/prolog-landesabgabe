import { createSyncStoragePersister } from '@tanstack/query-sync-storage-persister';
import { QueryClient, useQuery, UseQueryResult } from '@tanstack/react-query';
import defaultKeycloak from '@/config/KeycloakConfig';
import { TaskResult } from './Task';

interface PrototypeRequestBody {
  taskConfiguration: {
    args: any[];
    lang: string;
    id: string;
    root_id: string;
    parent_id: string;
    group_id: string;
  };
  metaConfiguration: {
    contentEncoding: string;
    contentType: string;
    replyTo: string;
    headerTask: string;
    headerTaskId: string;
    task: string;
  };
}

const buildPrototypeRequestBody = (args: any[], task: string): PrototypeRequestBody => {
  return {
    taskConfiguration: {
      args: args,
      lang: 'py',
      id: '',
      root_id: '',
      parent_id: '',
      group_id: '',
    },
    metaConfiguration: {
      contentEncoding: 'UTF-8',
      contentType: 'application/json',
      replyTo: 'response_prototype_8',
      headerTask: 'task',
      headerTaskId: 'taskId',
      task: task,
    },
  };
};

const buildHeaders = (contentType: string): any => {
  if (defaultKeycloak.isTokenExpired()) {
    defaultKeycloak.updateToken();
  }

  return {
    'Content-Type': contentType,
    'Authorization': `Bearer ${defaultKeycloak.token!}`,
  };
};

const buildRequestInit = (
  mode: RequestMode,
  method: string,
  headers: any,
  body?: any
): RequestInit => {
  return {
    mode: mode,
    method: method,
    headers: headers,
    body: body ?? null,
  };
};

async function post<T>(url: URL, body: any): Promise<T> {
  const headers = buildHeaders('application/json');
  const options: RequestInit = buildRequestInit('cors', 'POST', headers, JSON.stringify(body));
  const response = await fetch(url, options);
  return await response.json();
}

const createOptions = (contentType: string = 'text/x-prolog') => {
  const headers = buildHeaders(contentType);
  const options: RequestInit = buildRequestInit('cors', 'GET', headers);
  return options;
};

async function get<T>(url: URL): Promise<T> {
  const options = createOptions();
  const response = await fetch(url, options);
  return await response.json();
}

async function getString(url: URL): Promise<string> {
  const options = createOptions();
  const response = await fetch(url, options);
  return await response.text();
}

export const persister = createSyncStoragePersister({
  storage: window.localStorage,
});

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      gcTime: 1000 * 60 * 60 * 24, // 24 hours
    },
  },
});

export function useGetWebServerJSON<T>(urlSuffix: string): UseQueryResult<T, Error> {
  return useQuery({
    queryKey: [urlSuffix],
    queryFn: (): Promise<T> => get<T>(new URL(import.meta.env.VITE_SERVER_URL + urlSuffix)),
    enabled: true,
  });
}

export const useGetWebServerString = (urlSuffix: string): UseQueryResult<string, Error> => {
  return useQuery({
    queryKey: [urlSuffix],
    queryFn: (): Promise<string> => getString(new URL(import.meta.env.VITE_SERVER_URL + urlSuffix)),
    enabled: true,
  });
};

