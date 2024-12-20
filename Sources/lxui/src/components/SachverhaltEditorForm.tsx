import { LandesabgabeSachverhalt } from "@/model/PrologTemplates";
import { useEffect, useState } from "react";
import { PersonForm } from "./PersonForm";
import { Paper, Flex, Code, Accordion } from "@mantine/core";
import { PrologVM } from "../model/PrologVM";
import { v4 as uuidv4 } from 'uuid';
import { PrologFile } from "@/model/PrologFileSystem";

export function SachverhaltForm({ sachverhalt, prologVM }: {
    sachverhalt: LandesabgabeSachverhalt,
    prologVM: PrologVM
}) {
    const [code, setCode] = useState<string>();
    const [factBase, setFactBase] = useState<PrologFile[]>([]);
    const [persons, setPersons] = useState<[string, JSX.Element][]>([generateNewPersonForm()]);

    function generateNewPersonForm(): [string, JSX.Element] {
        const uuid = uuidv4();
        const personForm = <PersonForm key={uuid}
            sachverhalt={sachverhalt}
            faceBase={factBase}
            setFactBase={setFactBase} />;
        return [uuid, personForm];
    }

    useEffect(() => {
        async function f() {
            const result = await prologVM.evaluate();
            setCode(result);
        }

        f();
    }, [sachverhalt, persons, factBase]);

    return <Flex
        mih={50}
        gap="xs"
        justify="flex-start"
        align="center"
        direction="row"
        wrap="wrap">
        <FactBaseView factBase={factBase} />
        <FormView persons={persons} />
        <CodeView code={code} />
    </Flex >;
}

function FactBaseView({ factBase }: { factBase: PrologFile[] }) {
    return <Paper shadow="xs"
        p="xl"
        m="sm">
        <PrologFilesAccordion factBase={factBase} />
    </Paper>;
}

function CodeView({ code }: { code: string | undefined }) {
    return <Paper shadow="xs"
        p="xl"
        m="sm">
        <Code>{code}</Code>
    </Paper>
}

function FormView({ persons }: { persons: [string, JSX.Element][] }) {
    return <Paper shadow="xs"
        p="xl"
        m="sm">
        {persons.map((x) => x[1])}
    </Paper>;
}

function PrologFilesAccordion({ factBase }: { factBase: PrologFile[] }) {
    return factBase.map((x) => <>
        {x.name}
    </>);
    //return factBase.map((x: PrologFile) =>
    //    <Accordion.Item key={x.name} value={x.name}>
    //        <Accordion.Panel>{x.content}</Accordion.Panel>
    //    </Accordion.Item>
    //);
}