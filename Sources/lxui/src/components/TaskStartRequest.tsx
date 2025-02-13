import { useCallbackRef } from '@mantine/hooks';
import { usePostNormTransformationTaskStartRequest } from '@/util/BackendQueryProvider';
import { Box, LoadingOverlay, Paper, Text } from '@mantine/core';
import { useEffect } from 'react';
import { useQueryClient } from '@tanstack/react-query';

interface TaskStartRequestViewProps {
  selection: string;
  setTaskId: (taskId: string) => void;
}

export const TaskStartRequest = ({ selection, setTaskId }: TaskStartRequestViewProps) => {
  const queryClient = useQueryClient();
  const { status, data, error, isLoading, isError, isSuccess } =
    usePostNormTransformationTaskStartRequest(selection);

  useEffect(() => {
    if (isSuccess) {
        setTaskId(data!.task_id)
    }
  }, [status]);

  return (
    <>
      <Box pos="relative">
        <LoadingOverlay
          visible={isLoading}
          zIndex={1000}
          overlayProps={{ radius: 'sm', blur: 2 }}
        />
        {
          <Paper shadow="sm" p="xl" m="sm">
            {isError && <Text>Error: {error?.message}</Text>}
          </Paper>
        }
      </Box>
    </>
  );
};
