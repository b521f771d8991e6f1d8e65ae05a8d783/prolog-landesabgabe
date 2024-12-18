import { LandesabgabeSachverhalt } from "@/model/PrologTemplates";
import { useEffect, useState } from "react";
import { PersonForm } from "./PersonForm";
import { Paper, Code, Divider } from "@mantine/core";
import { getRechtsbestand } from "@/model/PrologFileSystem";
import { PrologVM } from "../model/PrologVM";

export function SachverhaltForm({ sachverhalt }: { sachverhalt: LandesabgabeSachverhalt }) {
    function generateNewPersonForm() {
        return <PersonForm sachverhalt={sachverhalt} />;
    }

    const [code, setCode] = useState<string>();
    const [persons, setPersons] = useState<JSX.Element[]>([generateNewPersonForm()]);
    const pvm = new PrologVM();

    function addButtonClicked() {
        setPersons([...persons, generateNewPersonForm()]);
    }

    return <Paper>
        {persons}
        <Divider my="md" />
        <Code>{code}</Code>
    </Paper>;
}