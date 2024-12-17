import { LandesabgabePerson, LandesabgabeSachverhalt } from "@/model/prologTemplates";
import { useState } from "react";
import { PersonForm } from "./PersonForm";
import { Button, Paper, Center, Code, Flex } from "@mantine/core";

export function SachverhaltForm({ sachverhalt }: { sachverhalt: LandesabgabeSachverhalt }) {
    const [persons, setPersons] = useState<JSX.Element[]>([generateNewPersonForm()]);

    function generateNewPersonForm() {
        return <PersonForm sachverhalt={sachverhalt} />;
    }

    function addButtonClicked() {
        setPersons([...persons, generateNewPersonForm()]);
    }

    console.log(persons.length === 0);

    return <Paper>
        {persons}

        <Code>
            $ lx
            wrfgw
        </Code>
    </Paper>;
}