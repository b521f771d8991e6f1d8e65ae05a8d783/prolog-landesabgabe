import { LandesabgabeSachverhalt } from "@/model/PrologTemplates";
import { useEffect, useId, useState } from "react";
import { PersonForm } from "./PersonForm";
import { Paper, Code, Divider } from "@mantine/core";
import { PrologVM } from "../model/PrologVM";

export function SachverhaltForm({ sachverhalt, prologVM }: { sachverhalt: LandesabgabeSachverhalt, prologVM: PrologVM }) {
    const [code, setCode] = useState<string>();
    const [persons, setPersons] = useState<JSX.Element[]>([generateNewPersonForm()]);

    function generateNewPersonForm() {
        return <PersonForm sachverhalt={sachverhalt} prologVM={prologVM} />;
    }

    useEffect(() => {
        async function f() {
            const result = await prologVM.evaluate();
            setCode(result);
        }

        f();
    }, [sachverhalt, persons]);

    return <Paper>
        {persons}
        <Divider my="md" />
        <Code>{code}</Code>
    </Paper>;
}