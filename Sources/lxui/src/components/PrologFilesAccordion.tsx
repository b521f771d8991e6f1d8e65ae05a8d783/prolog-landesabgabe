import React, { useEffect, useState } from 'react';
import { v7 } from 'uuid';
import {
  Anchor,
  Box,
  Button,
  Center,
  Flex,
  Input,
  List,
  LoadingOverlay,
  Modal,
  Paper,
  Text,
  Title,
  Loader
} from '@mantine/core';
import { PrologFile, PrologFileType } from '@/model/PrologFileSystem';
import { useGetWebServerJSON } from '@/util/BackendQueryProvider';
import { CodeView } from './CodeView';
import GenericWebServerRequest from './GenericWebServerRequest';

interface PrologFilesAccordionProps {
  factBase: PrologFile[];
  width: number;
  addToFactBase: (newFile: PrologFile) => void;
}

export function PrologFilesAccordion({
  factBase,
  width,
  addToFactBase,
}: PrologFilesAccordionProps) {
  const laws = factBase.filter((x) => x.prologFileType === PrologFileType.LAW);
  const mereFacts = factBase.filter((x) => x.prologFileType === PrologFileType.FACT);

  return (
    <Paper shadow="sm" p="xl" m="sm" w={width}>
      <Title>Wissensbasis</Title>

      <LawView title={'Gesetze'} laws={laws} addToFactBase={addToFactBase} />

      <Title order={2}>Fakten</Title>
      {mereFacts.length > 0 && (
        <>
          <Text size="xs">Fakten werden im Sachverhalt angezeigt</Text>
          {mereFacts.map((x) => (
            <PrologFileView pf={x} key={x.name} />
          ))}
        </>
      )}

      <Center>
        <Button leftSection={'⚒️'} disabled>
          Fakten manuell hinzufügen
        </Button>
      </Center>
    </Paper>
  );
}

interface LawViewProps {
  title: string;
  laws: PrologFile[];
  addToFactBase: (newFile: PrologFile) => void;
}

function LawView({ title, laws, addToFactBase }: LawViewProps) {
  const [addLawFromLibraryView, setAddLawFromLibraryView] = useState<boolean>(false);
  const [searchError, setSearchError] = useState<string | undefined>('');
  const [searchFieldValue, setSearchFieldValue] = useState<string>('');

  function resetLawView() {
    setAddLawFromLibraryView(false);
    setSearchFieldValue('');
    setSearchError(undefined);
  }

  function addLawFromLibraryClicked() {
    setAddLawFromLibraryView(true);
    setSearchFieldValue('');
  }

  function closeModalView() {
    resetLawView();
  }

  return (
    <>
      <Title order={2}>{title}</Title>

      {laws.length > 0 && (
        <>
          <Text size="xs">
            Gesetze werden als Hintergrundinformationen geladen und nicht im Sachverhalt angezeigt
          </Text>
          {laws.map((x) => (
            <PrologFileView pf={x} key={x.name} />
          ))}
        </>
      )}

      <Center>
        <Flex
          className={'select-none'}
          mih={50}
          gap="xs"
          justify="center"
          align="center"
          direction="row"
          wrap="wrap"
        >
          <Button leftSection={'⚖️'} onClick={addLawFromLibraryClicked}>
            Gesetz aus Bibliothek hinzufügen
          </Button>
          <ModalView
            addLawFromLibraryView={addLawFromLibraryView}
            closeModalView={closeModalView}
            addPrologFileToLibrary={addToFactBase}
          />
          <Button leftSection={'✏️'} disabled>
            Gesetze manuell hinzufügen
          </Button>
        </Flex>
      </Center>
    </>
  );
}

interface ModalViewProps {
  addLawFromLibraryView: boolean;
  closeModalView: () => void;
  addPrologFileToLibrary: (result: PrologFile) => void;
}

function ModalView({
  addLawFromLibraryView,
  closeModalView: closeModalView,
  addPrologFileToLibrary,
}: ModalViewProps) {
  const [loadError, setLoadError] = useState<string | undefined>(undefined);
  const [lawLibrary, setLawLibrary] = useState<string[]>([]);
  const [searchText, setSearchText] = useState<string>('');
  const [searchError, setSearchError] = useState<string>('');
  const [isSearchInProgress, setIsSearchInProgress] = useState<boolean>(false);

  const { data, error, isLoading, isError, isSuccess } = useGetWebServerJSON<string[]>('fetch-law');

  useEffect(() => {
    if (isSuccess) {
      setLawLibrary(JSON.parse(JSON.stringify(data!)) as string[]);
    }

    if (isError) {
      setLoadError(error!.message);
    }
  }, [isSuccess, isError]);

  const searchConcludedCallback = (result: string) => {
    setIsSearchInProgress(() => false);
    const kurztitel = searchText;
    setSearchText(() => '');
    setSearchError(() => '');
    addPrologFileToLibrary(new PrologFile(kurztitel, result, undefined, PrologFileType.LAW));
    closeModalView();
  };

  const searchErrorCallback = (errorMessage: string) => {
    setIsSearchInProgress(() => false);
    setSearchError(() => 'Nichts gefunden 😞');
    console.error(errorMessage);
  };

  const searchButtonClicked = () => {
    setIsSearchInProgress(() => true);
  };

  return (
    <Modal
      opened={addLawFromLibraryView}
      onClose={closeModalView}
      title="Gesetz aus Bibliothek hinzufügen"
    >
      <Flex gap="xs" justify="center" align="center" direction="column" wrap="wrap">
        <Input
          radius="lg"
          value={searchText!}
          onChange={(event) => setSearchText(event.currentTarget.value)}
          rightSection={
            searchText !== '' ? (
              <Input.ClearButton onClick={() => setSearchText(() => '')} />
            ) : undefined
          }
          rightSectionPointerEvents="auto"
          placeholder="Kurztitel"
          error={searchError}
        />

        <Button leftSection={'🔍'} onClick={searchButtonClicked}>
          Suchen & Hinzufügen
        </Button>
        {isSearchInProgress && searchText !== '' && (
          <GenericWebServerRequest
            urlSuffix={'fetch-law?kurztitel=' + searchText}
            callback={searchConcludedCallback}
            errorCallback={searchErrorCallback}
          />
        )}

        <Box pos="relative">
          <LoadingOverlay
            visible={isLoading}
            zIndex={1000}
            overlayProps={{ radius: 'sm', blur: 2 }}
          />
          <Flex gap="xs" justify="left" align="left" direction="column" wrap="wrap">
            {loadError && <Text c="red">Error: {loadError}</Text>}
            {lawLibrary.length == 0 ? (
              <Text>Keine Gesetze am Server gefunden</Text>
            ) : (
              <>
                <Text td="underline">Am Server sind folgende Gesetze verfügbar:</Text>
                <List>
                  {lawLibrary.map((x) => (
                    <List.Item key={v7()}>{x}</List.Item>
                  ))}
                </List>
              </>
            )}
          </Flex>
        </Box>
      </Flex>
    </Modal>
  );
}

function PrologFileView({ pf }: { pf: PrologFile }) {
  const [loadingIndicator, setLoadingIndicator] = useState<boolean>(true);
  const [langtitel, setLangtitel] = useState<string>();
  const [kurztitel, setKurztitel] = useState<string>();
  const [link, setLink] = useState<string>();
  const [titel, setTitel] = useState<string>();

  useEffect(() => {
    async function effect() {
      function extract(x: any): string | undefined {
        if (x && x[0] && x[0].X !== undefined) {
            return String(x[0].X);
        } else {
            return undefined; 
        }
    }
      const l: string | undefined = extract(await pf.queryThisFile(`langtitel(${pf.name}, X).`));
      const k: string | undefined = extract(await pf.queryThisFile(`kurztitel(${pf.name}, X).`));
      const u: string | undefined = extract(await pf.queryThisFile(`link(${pf.name}, X).`));
      const t: string | undefined = extract(await pf.queryThisFile(`titel(${pf.name}, X).`));
    
      setLangtitel(l);
      setKurztitel(k);
      setLink(u);
      setTitel(t);
      setLoadingIndicator(false);
    }

    effect();
  }, [pf]);

  return <>
      {loadingIndicator && <Center my={10}>
        <Loader color="rgba(0, 0, 0, 1)" />
      </Center>}
      {!loadingIndicator && <details>
        <summary>{titel ?? pf.name}</summary>
        {kurztitel && <Text size="xs"><u>Kurztitel:</u> {kurztitel} {link && <Anchor href={link}>(Volltext-Link)</Anchor>}</Text>}
        {langtitel && <Text size="xs"><u>Langtitel</u>: {langtitel}</Text>}
        <CodeView
          code={pf.evaluatedProlog}
          language="code"
          h={300}
          fileName={pf.name.replaceAll('/', '-')}
        />
      </details>}
    </>;
}
