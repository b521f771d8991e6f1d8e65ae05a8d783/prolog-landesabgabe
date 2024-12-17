import { PersonForm } from '@/components/PersonForm';
import { Center, Code, Flex, Title } from '@mantine/core';
import { SachverhaltForm } from '@/components/SachverhaltEditorForm';
import { LandesabgabeSachverhalt } from '@/model/prologTemplates';

export function HomePage() {
  const sachverhalt = new LandesabgabeSachverhalt();

  return <Flex
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
