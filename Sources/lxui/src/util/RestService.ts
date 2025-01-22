import { QueryClient, useQuery, useQueryClient, UseQueryResult } from '@tanstack/react-query';

export interface PrototypeRequestBody {
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

export enum TaskStatus {
  NOT_STARTED,
  UPLOADING = 'UPLOADING',
  PENDING = 'PENDING',
  PROGRESS = 'PROGRESS',
  SUCCESS = 'SUCCESS',
  FAILURE = 'FAILURE',
  ABORTED = 'ABORTED',
  FINISHED = 'FINISHED',
}

export enum TaskName {
  MSG_PROPOSAL_GEN = 'nlp_workers.generate_mail_proposal',
  SUMMARIZE_ATTACHMENT = 'nlp_workers.summarize_attachments',
}

export interface TaskResult {
  task_id: string;
  status: TaskStatus;
  result: string;
  score: number;
  sourceLanguage: string;
  targetLanguage: string;
}

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      gcTime: 1000 * 60 * 60 * 24, // 24 hours
    },
  },
});

export function usePostNormTransformationTaskStartRequest(
  selection: string
): UseQueryResult<TaskResult, Error> {
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

export function usePostTaskStatusRequest(id: string): UseQueryResult<TaskResult, Error> {
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

async function post<T>(url: URL, body: any): Promise<T> {
  const headers = buildHeaders();
  const options: RequestInit = buildRequestInit('cors', 'POST', headers, JSON.stringify(body));
  const response = await fetch(url, options);
  return await response.json();
}

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
