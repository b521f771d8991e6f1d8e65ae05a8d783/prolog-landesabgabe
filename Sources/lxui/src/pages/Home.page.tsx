import { Flex, Title } from '@mantine/core';
import { SachverhaltForm } from '@/components/SachverhaltEditorForm';
import { LandesabgabeSachverhalt } from '@/model/PrologTemplates';
import { PrologVM } from '@/model/PrologVM';
import { useEffect } from 'react';

import logo from "../../../../Resources/logo.svg";

function setFavicon(svgDataURL: string) {
  const link = document.createElement("link");
  link.rel = "shortcut icon";
  link.type = "image/svg+xml";
  link.href = svgDataURL;
  document.head.appendChild(link);
};

function setTitle(title: string) {
  document.title = title;
}

export function HomePage({ prologVM }: { prologVM: PrologVM }) {
  const sachverhalt = new LandesabgabeSachverhalt();

  useEffect(() => {
    setTitle("LXUI");
    setFavicon(logo);
  }, []);

  return <Flex className={"select-none"}
    mih={50}
    gap="xs"
    justify="center"
    align="center"
    direction="column"
    wrap="wrap">
    <Title>Sachverhalts-Editor</Title>
    <SachverhaltForm sachverhalt={sachverhalt} prologVM={prologVM} />
  </Flex>;
}

