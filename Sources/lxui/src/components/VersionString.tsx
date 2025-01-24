import { defaultConfig } from "@/config/ServerConfig";
import { useState, useEffect } from "react";
import { Text } from "@mantine/core";

export function VersionString() {
  const [version, setVersion] = useState<JSX.Element>(<></>);

  useEffect(() => {
    async function d() {
      const versionRequest = await fetch(`${defaultConfig.getServerProtocol()}://${defaultConfig.getServerName()}:${defaultConfig.getServerPort()}/version`, {
        mode: "cors"
      });

      if (!versionRequest.ok) {
        console.error(versionRequest);
        setVersion(<Text c="red">Could not connect to server</Text>);
      }

      setVersion(<>{await versionRequest.text()}</>);
    }

    d();
  }, []);

  return version;
}