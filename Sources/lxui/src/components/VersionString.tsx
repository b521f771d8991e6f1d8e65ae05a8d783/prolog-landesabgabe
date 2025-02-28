import { useEffect, useState } from 'react';
import { Text } from '@mantine/core';
import { useGetWebServerString } from '@/util/BackendQueryProvider';

export function VersionString({ successFormat = "dimmed", prefix = "Version: " }: {
  successFormat?: string,
  prefix?: string
}) {
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
      {isSuccess && <Text c={successFormat}>{prefix}{version}</Text>}
      {isError && <Text c="red">Could not connect to server</Text>}
    </>
  );
}
