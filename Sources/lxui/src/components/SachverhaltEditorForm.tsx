import { LandesabgabeHandlung, LandesabgabePerson, LandesabgabeSachverhalt } from "@/model/PrologTemplates";
import { Input, Text, Button, NumberInput, Flex, Paper } from "@mantine/core";
import { useState } from "react";
import { PersonForm } from "./PersonForm";
import { v4 as uuidv4 } from 'uuid';
import { AddFactFileFunction } from "@/model/PrologFileSystem";
import { WIDTH } from "@/pages/Home.page";

/*
* This component is used to edit a LandesabgabeSachverhalt. It allows adding
* multiple Personen to the Sachverhalt.
*/
export function SacherhaltEditorForm({ addFacts, sachverhalt, initialPersons, width }: {
    addFacts: AddFactFileFunction,
    sachverhalt: LandesabgabeSachverhalt
    initialPersons?: [LandesabgabePerson, LandesabgabeHandlung[]][],
    width: number
}) {
    const [vorname, setVorname] = useState<string>("");
    const [nachname, setNachname] = useState<string>("");
    const [alter, setAlter] = useState<number>(0);
    const [handlungen, setHandlungen] = useState<[string, JSX.Element][]>(initialPersons?.map(personFormFromState) ?? []);

    function personFormFromState(state: [LandesabgabePerson, LandesabgabeHandlung[]]): [string, JSX.Element] {
        const uuid = uuidv4();
        return [uuid, <PersonForm key={uuid}
            person={state[0]}
            addFacts={addFacts}
            initialHandlungen={state[1]} />];
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

    return <Paper
        shadow="xs"
        p="xl"
        m="sm"
        w={width}>
        <Flex
            mih={50}
            gap="xs"
            justify="flex-start"
            align="center"
            direction="column"
            wrap="wrap">
            <Toolbar vorname={vorname}
                setVorname={setVorname}
                nachname={nachname}
                setNachname={setNachname}
                alter={alter}
                setAlter={setAlter}
                addButtonClicked={addButtonClicked} />

            <Text ta="left">Im Sachverhalt sind folgende Personen enthalten:</Text>
            {handlungen.map((x) => x[1])}
        </Flex>
    </Paper>;
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

        <Button disabled={vorname === undefined || nachname === undefined || alter === undefined || vorname === "" || nachname === "" || alter === 0}
            onClick={addButtonClicked}>
            Person hinzufügen
        </Button>
    </Flex>;
}

