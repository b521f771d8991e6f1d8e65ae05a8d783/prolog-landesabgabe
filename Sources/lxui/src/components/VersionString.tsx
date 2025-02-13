import { useEffect, useState } from 'react';
import { Text } from '@mantine/core';
import { useGetWebServerString } from '@/util/BackendQueryProvider';

export function VersionString() {
  const [version, setVersion] = useState<string | null>(null);
  const { data, error, isError, isSuccess } = useGetWebServerString('version');

  useEffect(() => {
    if (isSuccess) {
      setVersion(() => data!);
    }

    if (isError) {
      console.error(error);
      setVersion(() => null);
    }
  }, [isSuccess, isError, data]);

  return (
    <>
      {isSuccess && <Text c="dimmed">Version: {version}</Text>}
      {isError && <Text c="red">Could not connect to server</Text>}
    </>
  );
}
