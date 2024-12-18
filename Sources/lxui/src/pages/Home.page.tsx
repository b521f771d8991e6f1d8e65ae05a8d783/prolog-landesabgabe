import { Flex, Title } from '@mantine/core';
import { SachverhaltForm } from '@/components/SachverhaltEditorForm';
import { LandesabgabeSachverhalt } from '@/model/PrologTemplates';

export function HomePage() {
  const sachverhalt = new LandesabgabeSachverhalt();

  return <Flex
    className={"select-none"}
    mih={50}
    gap="xs"
    justify="center"
    align="center"
    direction="column"
    wrap="wrap">
    <Title>Sachverhalts-Editor</Title>

    <SachverhaltForm sachverhalt={sachverhalt}>
    </SachverhaltForm>
  </Flex>;
}
