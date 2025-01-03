import { LandesabgabeHandlung, LandesabgabePerson, LandesabgabeSachverhalt } from "@/model/PrologTemplates";
import { Input, Text, Button, NumberInput, Flex } from "@mantine/core";
import { useState } from "react";
import { PersonForm } from "./PersonForm";
import { v4 as uuidv4 } from 'uuid';
import { AddFactFileFunction } from "@/model/PrologFileSystem";

/*
* This component is used to edit a LandesabgabeSachverhalt. It allows adding
* multiple Personen to the Sachverhalt.
*/
export function SacherhaltEditorForm({ addFacts, sachverhalt, initialPersons }: {
    addFacts: AddFactFileFunction,
    sachverhalt: LandesabgabeSachverhalt
    initialPersons?: [LandesabgabePerson, LandesabgabeHandlung[]][],
}) {
    const [vorname, setVorname] = useState<string>("");
    const [nachname, setNachname] = useState<string>("");
    const [alter, setAlter] = useState<number>(0);
    const [handlungen, setHandlungen] = useState<[string, JSX.Element][]>([]);

    function personFomFromState(state: [LandesabgabePerson, LandesabgabeHandlung[]]): [string, JSX.Element] {
        const uuid = uuidv4();
        return [uuid, <PersonForm key={uuid}
            person={state[0]}
            addFacts={addFacts} />];
    }

    function generateNewHandlungForm(): [string, JSX.Element] {
        const person = new LandesabgabePerson(sachverhalt, vorname!, nachname!, alter!);
        const uuid = uuidv4();
        return [uuid, <PersonForm key={uuid}
            person={person}
            addFacts={addFacts} />];
    }

    function addButtonClicked() {
        setHandlungen([...handlungen, generateNewHandlungForm()]);
    }

    return <>
        <Toolbar vorname={vorname}
            setVorname={setVorname}
            nachname={nachname}
            setNachname={setNachname}
            alter={alter}
            setAlter={setAlter}
            addButtonClicked={addButtonClicked} />

        <Text>Im Sachverhalt sind folgende Personen enthalten:</Text>
        {handlungen.map((x) => x[1])}
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
        <Text mb={4}>Vorname:</Text>
        <Input
            value={vorname}
            onChange={(event) => setVorname(event.target.value)}
            placeholder="Geben Sie Ihren Vornamen ein" />

        <Text mb={4}>Nachname:</Text>
        <Input
            value={nachname}
            onChange={(event) => setNachname(event.target.value)}
            placeholder="Geben Sie Ihren Nachnamen ein" />

        <Text mb={4}>Alter:</Text>

        <NumberInput
            value={alter}
            onChange={(event) => {
                if (typeof event === "number") {
                    setAlter(event);
                }
                else {
                    console.error("Unknown type");
                }
            }}
            placeholder="Geben Sie Ihren Nachnamen ein" />

        <Button disabled={vorname === undefined || nachname === undefined || alter === undefined}
            onClick={addButtonClicked}>
            Person hinzufügen
        </Button>
    </Flex>;
}

