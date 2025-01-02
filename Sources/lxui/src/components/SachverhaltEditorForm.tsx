import { LandesabgabeSachverhalt } from "@/model/PrologTemplates";
import { useEffect, useId, useRef, useState } from "react";
import { PersonForm } from "./PersonForm";
import { Paper, Flex, Code, Button, Center } from "@mantine/core";
import { AppState } from "../model/AppState";
import { v4 as uuidv4 } from 'uuid';
import { PrologFile } from "@/model/PrologFileSystem";

import "highlight.js/styles/github.css";
import hljs from "highlight.js";

/*
 * This component is responsible for displaying a Sachverhalt
*/
export function SachverhaltForm({ sachverhalt, prologVM }: {
    sachverhalt: LandesabgabeSachverhalt,
    prologVM: AppState
}) {
    const [code, setCode] = useState<string>();
    const [factBase, setFactBase] = useState<PrologFile[]>(prologVM.getFactBase());
    const [persons, setPersons] = useState<[string, JSX.Element][]>([generateNewPersonForm()]);

    console.log("Loaded fact base:", factBase);

    prologVM.addFactBaseListener((changedFactBase: PrologFile[]) => {
        setFactBase(changedFactBase);
    });

    function generateNewPersonForm(): [string, JSX.Element] {
        const uuid = uuidv4();
        const personForm = <PersonForm key={uuid}
            sachverhalt={sachverhalt}
            prologVM={prologVM} />;
        return [uuid, personForm];
    }

    useEffect(() => {
        async function f() {
            const result = await prologVM.evaluate();
            setCode(result);
        }

        f();
    }, [sachverhalt, persons, prologVM]);

    return <Flex
        mih={50}
        gap="xs"
        justify="flex-start"
        align="center"
        direction="row"
        wrap="wrap">
        <FactBaseView factBase={factBase} />
        <FormView persons={persons} />
        <ResultView code={code} />
    </Flex >;
}

function FactBaseView({ factBase }: { factBase: PrologFile[] }) {
    return <Paper shadow="xs"
        p="xl"
        m="sm">
        <PrologFilesAccordion factBase={factBase} />
    </Paper>;
}

function ResultView({ code }: { code: string | undefined }) {
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
        <details>
            <summary>{x.name}</summary>
            <Code block>
                <PrologCodeBlock prologCode={x.content} />
            </Code>
        </details>
    </>);
}

function PrologCodeBlock({ prologCode }: { prologCode: string }) {
    const codeRef = useId();

    useEffect(() => {
        const codeElement = document.getElementById(codeRef);

        if (codeElement) {
            hljs.highlightElement(codeElement);
        }
    }, [prologCode]);

    return <Code block>
        <code id={codeRef} className="prolog">
            {prologCode}
        </code>
        <Center>
            <Button disabled>In Normtext konvertieren 🪄</Button>
        </Center>
    </Code>
}