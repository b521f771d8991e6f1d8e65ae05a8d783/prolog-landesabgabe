import { PrologFile } from "@/model/PrologFileSystem";
import { LandesabgabeSachverhalt, LandesabgabePerson, LandesabgabeHandlung } from "@/model/PrologTemplates";
import { Title, Text, Flex, NumberInput, Input, Button } from "@mantine/core";
import { useState, useMemo } from "react";
import { PersonForm } from "./PersonForm";

export function FactFile({ prologFile, addHandlung, addPerson }: {
    prologFile: PrologFile,
    addHandlung: (handlung: LandesabgabeHandlung) => void,
    addPerson: (person: LandesabgabePerson) => void
}) {
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
            ? persons.map((x) => <PersonForm
                person={x}
                addHandlung={addHandlung} />)
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

