import { LandesabgabeSachverhalt } from "@/model/prologTemplates";
import { useState } from "react";
import { PersonForm } from "./PersonForm";
import { Paper, Code, Divider } from "@mantine/core";
import { getRechtsbestand } from "@/model/prologFileset";

export function SachverhaltForm({ sachverhalt }: { sachverhalt: LandesabgabeSachverhalt }) {
    getRechtsbestand().then((x) => console.log(x));

    const [persons, setPersons] = useState<JSX.Element[]>([generateNewPersonForm()]);

    function generateNewPersonForm() {
        return <PersonForm sachverhalt={sachverhalt} />;
    }

    function addButtonClicked() {
        setPersons([...persons, generateNewPersonForm()]);
    }

    console.assert(persons.length === 0);

    return <Paper>
        {persons}

        <Divider my="md" />

        <Code>
            $ lx
        </Code>
    </Paper>;
}