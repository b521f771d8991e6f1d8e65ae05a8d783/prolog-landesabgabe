import { LandesabgabeHandlung, LandesabgabePerson, LandesabgabeSachverhalt } from "@/model/PrologTemplates";
import { Input, Text, Button, NumberInput, Flex, Paper, Title } from "@mantine/core";
import { useMemo, useState } from "react";
import { PersonForm } from "./PersonForm";
import { AddFactFileFunction, PrologFile, PrologFileType } from "@/model/PrologFileSystem";
import { AppState } from "@/model/AppState";

/*
* This component is used to edit a LandesabgabeSachverhalt. It allows adding
* multiple Personen to the Sachverhalt.
*/
export function SachverhaltEditorForm({ addFacts, initialFactBase, width }: {
    addFacts: AddFactFileFunction,
    initialFactBase: PrologFile[],
    width: number
}) {
    const facts = useMemo<PrologFile[]>(() =>
        initialFactBase.filter((x) => x.prologFileType === PrologFileType.FACT),
        [initialFactBase]);
    const [currentFacts, setCurrentFacts] = useState<PrologFile[]>(facts);

    function addFactBase() {
        setCurrentFacts([
            ...currentFacts,
            new PrologFile(AppState.getUniqueFilename(), "", [], [], PrologFileType.FACT)
        ]);
    }

    return <Paper shadow="sm" p="xl" m="sm" w={width}>
        <Title>Faktenbasis bearbeiten</Title>
        <Button onClick={addFactBase}>Neue Faktenbasis</Button>

        {currentFacts.length > 0
            ? currentFacts.map((x: PrologFile) => <FactFile prologFile={x} />)
            : <Text>Keine Fakten gefunden</Text>
        }
    </Paper>;
}

function FactFile({ prologFile }: { prologFile: PrologFile }) {
    const [sachverhalt, setSachverhalt] = useState(new LandesabgabeSachverhalt());
    const initialPersons = useMemo<LandesabgabePerson[]>(() => {
        const sovereignPersons = prologFile.savedPersons;
        const persons = prologFile.handlungen.map((x) => x.person);
        const personsWithDuplicates = [...sovereignPersons, ...persons];

        return [...new Set(personsWithDuplicates)];
    }, [prologFile]);
    const [persons, setPersons] = useState<LandesabgabePerson[]>(initialPersons);

    const [vorname, setVorname] = useState<string>("");
    const [nachname, setNachname] = useState<string>("");
    const [alter, setAlter] = useState<number>(0);

    function addButtonClicked() {
        setPersons([
            ...persons,
            new LandesabgabePerson(sachverhalt, vorname, nachname, alter)
        ]);
    }

    return <>
        <Title order={4}>{prologFile.name}</Title>
        <Toolbar vorname={vorname}
            setVorname={setVorname}
            nachname={nachname}
            setNachname={setNachname}
            alter={alter}
            setAlter={setAlter}
            addButtonClicked={addButtonClicked} />

        {persons.length > 0
            ? persons.map((x) => <PersonForm person={x} />)
            : <Text>Keine Personen gefunden</Text>
        }
    </>;
}

function Toolbar({ vorname, setVorname, nachname, setNachname, alter, setAlter, addButtonClicked }: {
    vorname: string,
    setVorname: any,
    nachname: string,
    setNachname: any,
    alter: number,
    setAlter: any,
    addButtonClicked: any
}) {
    return <Flex
        mih={50}
        gap="xs"
        justify="flex-start"
        align="center"
        direction="row"
        wrap="wrap">
        <Input
            w={100}
            value={vorname}
            onChange={(event) => setVorname(event.target.value)}
            placeholder="Vorname" />
        <Input
            w={100}
            value={nachname}
            onChange={(event) => setNachname(event.target.value)}
            placeholder="Nachname" />
        <NumberInput
            w={80}
            value={alter}
            onChange={(event) => {
                if (typeof event === "number") {
                    setAlter(event);
                }
                else {
                    console.error("Unknown type");
                }
            }}
            placeholder="Alter" />

        <Button disabled={vorname === undefined || nachname === undefined || alter === undefined
            || vorname === "" || nachname === "" || alter === 0}
            onClick={addButtonClicked}>
            Person hinzufügen
        </Button>
    </Flex>;
}

