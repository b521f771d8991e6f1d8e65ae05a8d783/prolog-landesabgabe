import { LandesabgabePerson, LandesabgabeSachverhalt } from "@/model/prologTemplates";
import { useState } from "react";
import { PersonForm } from "./PersonForm";
import { Button, Paper, Center } from "@mantine/core";

export function SachverhaltForm() {
    function generateNewPersonForm() {
        return <>
            <PersonForm sachverhalt={sachverhalt}></PersonForm>
        </>;
    }

    const [sachverhalt, setSachverhalt] = useState(new LandesabgabeSachverhalt());
    const [persons, setPersons] = useState<JSX.Element[]>([generateNewPersonForm()]);

    function addButtonClicked() {
        setPersons([...persons, generateNewPersonForm()]);
    }

    return <Paper>
        {persons}

        <Center>
            <Button onClick={addButtonClicked}>
                Hinzufügen
            </Button>
        </Center>
    </Paper>;
}