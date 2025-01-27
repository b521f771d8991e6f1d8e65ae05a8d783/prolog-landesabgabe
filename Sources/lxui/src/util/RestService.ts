import { QueryClient, useQuery, useQueryClient, UseQueryResult } from '@tanstack/react-query';
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

const buildHeaders = (): any => {
  const credentials = btoa(`use:pw}`);
  return {
    'Content-Type': 'application/json',
    Accept: '*/*',
    Authorization: `Basic ${credentials}`, // FIXME change to Keycloak OAuth2
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
  
export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      gcTime: 1000 * 60 * 60 * 24, // 24 hours
    },
  },
});

export const usePostNormTransformationTaskStartRequest = (
  selection: string
): UseQueryResult<TaskResult, Error> => {
  return useQuery({
    queryKey: ['postNormTransformationTask'],
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
    queryKey: ['postNormTransformationTask'],
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
