import { PrologFile } from "@/model/PrologFileSystem";
import { Code, Center, Button, ScrollArea, Paper, Title } from "@mantine/core";
import hljs from "highlight.js";
import { useId, useEffect } from "react";

export function PrologFilesAccordion({ factBase, width }: { factBase: PrologFile[], width: number }) {
    return <Paper shadow="xs"
        p="xl"
        m="sm"
        w={width}>
        <Title>Faktenbasis</Title>
        {factBase.map((x) => <PrologFileView pf={x} />)}
        <Center>
            <Button disabled>Faktenbasis manuell hinzufügen</Button>
        </Center>
    </Paper>;
}

function PrologFileView({ pf }: { pf: PrologFile }) {
    function onFullScreenClicked() {
        // open a new window containing pf.content
        const blob = URL.createObjectURL(new Blob([pf.content], { type: "text/plain" }));
        window.open(blob);
    }

    return <>
        <details>
            <summary>{pf.name}</summary>
            <PrologCodeBlock prologCode={pf.content} h={300} />

            <Center>
                <Button onClick={onFullScreenClicked}>Vergrößern</Button>
                <Button disabled>In Normtext konvertieren 🪄</Button>
            </Center>
        </details>
    </>;
}

function PrologCodeBlock({ prologCode, h = 300 }: { prologCode: string, h: number }) {
    const codeRef = useId();

    useEffect(() => {
        const codeElement = document.getElementById(codeRef);

        if (codeElement) {
            hljs.highlightElement(codeElement);
        }
    }, [prologCode]);

    return <Code h={h} block>
        {prologCode}
    </Code>;
}
