import { useEffect } from 'react';
import { Box, LoadingOverlay, Paper, Text } from '@mantine/core';
import { useGetWebServerString } from '@/util/BackendQueryProvider';

interface WebServerRequestProps {
  urlSuffix: string;
  callback: (result: string) => void;
  errorCallback: (errorMessage: string) => void;
}

const GenericWebServerRequest = ({ urlSuffix, callback, errorCallback }: WebServerRequestProps) => {
  const { data, error, isLoading, isError, isSuccess } = useGetWebServerString(urlSuffix);

  useEffect(() => {
    if (isSuccess) {
      callback(data!);
      return;
    }

    if (isError) {
      errorCallback(error!.message);
    }
  }, [isSuccess, isError]);

  return (
    <>
      <Box pos="relative">
        <LoadingOverlay
          visible={isLoading}
          zIndex={1000}
          overlayProps={{ radius: 'sm', blur: 2 }}
        />
      </Box>
    </>
  );
};

export default GenericWebServerRequest;
