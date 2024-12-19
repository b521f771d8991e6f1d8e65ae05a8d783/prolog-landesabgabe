import { LandesabgabeSachverhalt } from "@/model/PrologTemplates";
import { useEffect, useId, useState } from "react";
import { PersonForm } from "./PersonForm";
import { Paper, Code, Divider } from "@mantine/core";
import { PrologVM } from "../model/PrologVM";
import { v4 as uuidv4 } from 'uuid';

export function SachverhaltForm({ sachverhalt, prologVM }: { sachverhalt: LandesabgabeSachverhalt, prologVM: PrologVM }) {
    const [code, setCode] = useState<string>();
    const [persons, setPersons] = useState<[string, JSX.Element][]>([generateNewPersonForm()]);

    function generateNewPersonForm(): [string, JSX.Element] {
        const uuid = uuidv4();
        const personForm = <PersonForm key={uuid} sachverhalt={sachverhalt} prologVM={prologVM} />;
        return [uuid, personForm];
    }

    useEffect(() => {
        async function f() {
            const result = await prologVM.evaluate();
            setCode(result);
        }

        f();
    }, [sachverhalt, persons]);

    return <Paper>
        {persons.map((x) => x[1])}
        <Divider my="md" />
        <Code>{code}</Code>
    </Paper>;
}