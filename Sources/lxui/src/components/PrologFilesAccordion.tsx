import { PrologFile } from "@/model/PrologFileSystem";
import { Code, Center, Button, ScrollArea, Paper } from "@mantine/core";
import hljs from "highlight.js";
import { useId, useEffect } from "react";

export function PrologFilesAccordion({ factBase }: { factBase: PrologFile[] }) {
    return <Paper shadow="xs"
        p="xl"
        m="sm">
        {factBase.map((x) => <PrologFileView pf={x} />)}
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
            <Code block>
                <PrologCodeBlock prologCode={pf.content} />
            </Code>

            <Center>
                <Button onClick={onFullScreenClicked}>Vergrößern</Button>
                <Button disabled>In Normtext konvertieren 🪄</Button>
            </Center>
        </details>
    </>;
}

function PrologCodeBlock({ prologCode }: { prologCode: string }) {
    const codeRef = useId();

    useEffect(() => {
        const codeElement = document.getElementById(codeRef);

        if (codeElement) {
            hljs.highlightElement(codeElement);
        }
    }, [prologCode]);

    return <Code>
        <ScrollArea w={300} h={200}>
            <code id={codeRef} className="prolog overflow-x-auto max-w-11">
                {prologCode}
            </code>
        </ScrollArea>
    </Code>
}
