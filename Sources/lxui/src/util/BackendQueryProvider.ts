import { QueryClient, useQuery, useQueryClient, UseQueryResult } from '@tanstack/react-query';
import { TaskResult } from './Task';
import { createSyncStoragePersister } from '@tanstack/query-sync-storage-persister'
import { defaultConfig } from '@/config/ServerConfig';
import defaultKeycloak from '@/config/KeycloakConfig';

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

const buildHeaders = (): any => {
  if (defaultKeycloak.isTokenExpired()) {
    defaultKeycloak.updateToken();
  }
  return {
    'Content-Type': 'application/json',
    'Authorization':`Bearer ${defaultKeycloak.token!}`
  };
};

const buildRequestInit = (
  mode: RequestMode,
  method: string,
  headers: any,
  body?: any
): RequestInit => {
  let requestInit = {
    mode: mode,
    method: method,
    headers: headers,
    body: null,
  };
  if (body) {
    requestInit.body = body;
  }
  return requestInit;
};

async function post<T>(url: URL, body: any): Promise<T> {
  const headers = buildHeaders();
  const options: RequestInit = buildRequestInit('cors', 'POST', headers, JSON.stringify(body));
  const response = await fetch(url, options);
  return await response.json();
}

async function get<T>(url: URL): Promise<T> {
  const headers = buildHeaders();
  const options: RequestInit = buildRequestInit('cors', 'GET', headers);
  const response = await fetch(url, options);
  return await response.json();
}
 
export const persister = createSyncStoragePersister({
  storage: window.localStorage,
})

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      gcTime: 1000 * 60 * 60 * 24, // 24 hours
    },
  },
});

//FIXME ADAPT SO IT CAN BE USED IN useGetWebServer
const baseUrl = `${defaultConfig.getServerProtocol()}://${defaultConfig.getServerName()}:${defaultConfig.getServerPort()}/v0/`;

export const useGetWebServer = (
  urlSuffix: string
): UseQueryResult<string, Error> => {
  return useQuery({
    queryKey: ['getWebServer'],
    queryFn: () =>
      get<string>(
        new URL('http://localhost:4433/prolog-web-server/v0/' + urlSuffix),
      ),
    enabled: false,
  });
}

export const usePostNormTransformationTaskStartRequest = (
  selection: string
): UseQueryResult<TaskResult, Error> => {
  return useQuery({
    queryKey: ['postNormTransformationTaskStartRequest'],
    queryFn: () =>
      post<TaskResult>(
        new URL('https://localhost:4020/prototype-pipeline/v0/prototype/8/task/celery/start/'),
        buildPrototypeRequestBody([selection], 'transformIntoNorm')
      ),
    enabled: false,
  });
}

export const usePostTaskStatusRequest = (id: string): UseQueryResult<TaskResult, Error> => {
  return useQuery({
    queryKey: ['postCeleryTaskStatusRequest'],
    queryFn: () =>
      post<TaskResult>(
        new URL(
          'https://localhost:4020/prototype-pipeline/v0/prototype/8/task/celery/status/' + id
        ),
        { task_id: id }
      ),
    enabled: false,
  });
}
