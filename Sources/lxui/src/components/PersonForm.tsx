import { LandesabgabePerson, LandesabgabeSachverhalt } from "@/model/PrologTemplates";
import { Input, Text, Button, Paper, Center, NumberInput, Flex, Divider } from "@mantine/core";
import { useId, useState } from "react";
import { HandlungForm } from "./HandlungForm";
import { PrologVM } from "@/model/PrologVM";

export function PersonForm({ sachverhalt, prologVM }: { sachverhalt: LandesabgabeSachverhalt, prologVM: PrologVM }) {
    const [vorname, setVorname] = useState<string>();
    const [nachname, setNachname] = useState<string>();
    const [alter, setAlter] = useState<number>();
    const [handlungen, setHandlungen] = useState<JSX.Element[]>([]);

    function generateNewHandlungForm() {
        const person = new LandesabgabePerson(sachverhalt, vorname!, nachname!, alter!);
        return <HandlungForm person={person} prologVM={prologVM} />;
    }

    function addButtonClicked() {
        setHandlungen([...handlungen, generateNewHandlungForm()]);
        setVorname("");
        setNachname("");
        setAlter(undefined); // somehow, this does not suffice
    }

    return <>
        <Toolbar vorname={vorname}
            setVorname={setVorname}
            nachname={nachname}
            setNachname={setNachname}
            alter={alter}
            setAlter={setAlter}
            addButtonClicked={addButtonClicked} />

        {handlungen}
    </>;
}

function Toolbar({ vorname, setVorname, nachname, setNachname, alter, setAlter, addButtonClicked }: {
    vorname: string | unknown,
    setVorname: any,
    nachname: string | unknown,
    setNachname: any,
    alter: number | unknown,
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

