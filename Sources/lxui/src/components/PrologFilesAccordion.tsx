import { PrologFile, PrologFileType } from "@/model/PrologFileSystem";
import { Input, Center, Button, Paper, Title, Flex, Text, Modal, List } from "@mantine/core";
import { CodeView } from "./CodeView";
import React, { useEffect, useState } from "react";
import { defaultConfig } from "@/config/ServerConfig";
import { v7 } from "uuid";

interface PrologFilesAccordionProps {
    factBase: PrologFile[],
    width: number,
    addToFactBase: (newFile: string) => Promise<boolean>
}

export function PrologFilesAccordion({ factBase, width, addToFactBase }: PrologFilesAccordionProps) {
    const laws = factBase.filter((x) => x.prologFileType === PrologFileType.LAW);
    const mereFacts = factBase.filter((x) => x.prologFileType === PrologFileType.FACT);

    return <Paper shadow="sm"
        p="xl"
        m="sm"
        w={width}>
        <Title>Wissensbasis</Title>

        <LawView
            title={"Gesetze"}
            laws={laws}
            addToFactBase={addToFactBase} />

        <Title order={2}>Fakten</Title>
        {mereFacts.length > 0 && <>
            <Text size="xs">Fakten werden im Sachverhalt angezeigt</Text>
            {mereFacts.map((x) => <PrologFileView pf={x} key={x.name} />)}
        </>}

        <Center>
            <Button leftSection={"⚒️"} disabled>Fakten manuell hinzufügen</Button>
        </Center>
    </Paper >;
}

interface LawViewProps {
    title: string,
    laws: PrologFile[],
    addToFactBase: (newFile: string) => Promise<boolean>
}

function LawView({ title, laws, addToFactBase }: LawViewProps) {
    const [addLawFromLibraryView, setAddLawFromLibraryView] = useState<boolean>(false);
    const [searchError, setSearchError] = useState<string | undefined>("");
    const [searchFieldValue, setSearchFieldValue] = useState<string>("");

    function resetLawView() {
        setAddLawFromLibraryView(false);
        setSearchFieldValue("");
        setSearchError(undefined);
    }

    function addLawFromLibraryClicked() {
        setAddLawFromLibraryView(true);
        setSearchFieldValue("");
    }

    async function searchInLibraryButtonClicked() {
        if (!await addToFactBase(searchFieldValue)) {
            setSearchFieldValue("");
            setSearchError("Nichts gefunden 😞");
        } else {
            resetLawView();
        }
    }

    function cancelButtonClicked() {
        resetLawView();
    }

    return <>
        <Title order={2}>{title}</Title>

        {laws.length > 0 && <>
            <Text size="xs">Gesetze werden als Hintergrundinformationen geladen und nicht im Sachverhalt angezeigt</Text>
            {laws.map((x) => <PrologFileView pf={x} key={x.name} />)}
        </>}

        <Center>
            <Flex className={"select-none"}
                mih={50}
                gap="xs"
                justify="center"
                align="center"
                direction="row"
                wrap="wrap">
                <Button leftSection={"⚖️"} onClick={addLawFromLibraryClicked}>Gesetz aus Bibliothek hinzufügen</Button>
                <ModalView
                    addLawFromLibraryView={addLawFromLibraryView}
                    cancelButtonClicked={cancelButtonClicked}
                    searchFieldValue={searchFieldValue}
                    setSearchFieldValue={setSearchFieldValue}
                    searchError={searchError}
                    searchInLibraryButtonClicked={searchInLibraryButtonClicked} />
                <Button leftSection={"✏️"} disabled>Gesetze manuell hinzufügen</Button>
            </Flex>
        </Center>
    </>;
}

interface ModalViewProps {
    addLawFromLibraryView: boolean;
    cancelButtonClicked: () => void;
    searchFieldValue: string;
    setSearchFieldValue: React.Dispatch<React.SetStateAction<string>>;
    searchError: string | undefined;
    searchInLibraryButtonClicked: () => Promise<void>;
}

function ModalView({ addLawFromLibraryView, cancelButtonClicked, searchFieldValue, setSearchFieldValue, searchError, searchInLibraryButtonClicked }: ModalViewProps) {
    const [loadError, setLoadError] = useState<string | undefined>(undefined);
    const [lawLibrary, setLawLibrary] = useState<string[]>([]);

    useEffect(() => {
        async function loadServerListAsync() {
            // TODO move all HTTP requests to their own class, Lukas has already done that
            const request = await fetch(`${defaultConfig.getServerProtocol()}://${defaultConfig.getServerName()}:${defaultConfig.getServerPort()}/fetch-law`);

            if (!request.ok) {
                setLoadError(request.statusText);
            }

            const lawLibrary = JSON.parse(await request.text()) as string[];
            setLawLibrary(lawLibrary);
        }

        loadServerListAsync();
    });

    return <Modal
        opened={addLawFromLibraryView}
        onClose={cancelButtonClicked}
        title="Gesetz aus Bibliothek hinzufügen">
        <Flex
            gap="xs"
            justify="center"
            align="center"
            direction="column"
            wrap="wrap">
            <Input
                radius="lg"
                value={searchFieldValue}
                onChange={(event) => setSearchFieldValue(event.currentTarget.value)}
                rightSection={searchFieldValue !== ""
                    ? <Input.ClearButton
                        onClick={() => setSearchFieldValue("")} />
                    : undefined}
                rightSectionPointerEvents="auto"
                placeholder="Kurztitel"
                error={searchError} />

            <Button
                leftSection={"🔍"}
                onClick={searchInLibraryButtonClicked}>
                Suchen & Hinzufügen
            </Button>

            <Flex
                gap="xs"
                justify="left"
                align="left"
                direction="column"
                wrap="wrap">
                {loadError && <Text c="red">Error: {loadError}</Text>}
                {lawLibrary.length == 0
                    ? <Text>Keine Gesetze am Server gefunden</Text>
                    : <>
                        <Text td="underline">Am Server sind folgende Gesetze verfügbar:</Text>
                        <List>
                            {lawLibrary.map((x) => <List.Item key={v7()}>{x}</List.Item>)}
                        </List>
                    </>}
            </Flex>
        </Flex>
    </Modal>;
}

function PrologFileView({ pf }: { pf: PrologFile }) {
    return <>
        <details>
            <summary>{pf.name}</summary>
            <CodeView
                code={pf.evaluatedProlog}
                language="code"
                h={300}
                fileName={pf.name.replaceAll("/", "-")} />
        </details >
    </>;
}
