import { PrologFile, PrologFileType } from "@/model/PrologFileSystem";
import { Code, Center, Button, Paper, Title, Flex } from "@mantine/core";
import hljs from "highlight.js";
import { useId, useEffect } from "react";

export function PrologFilesAccordion({ factBase, width }: { factBase: PrologFile[], width: number }) {
    const laws = factBase.filter((x) => x.prologFileType === PrologFileType.LAW);
    const mereFacts = factBase.filter((x) => x.prologFileType === PrologFileType.FACT);

    console.log(laws, mereFacts, factBase)

    return <Paper shadow="xs"
        p="xl"
        m="sm"
        w={width}>
        <Title>Wissensbasis</Title>

        {laws.length > 0 && <>
            <Title order={2}>Gesetze</Title>
            {laws.map((x) => <PrologFileView pf={x} />)}
        </>}

        {mereFacts.length > 0 && <>
            <Title order={2}>Fakten</Title>
            {mereFacts.map((x) => <PrologFileView pf={x} />)}
        </>}

        <Center>
            <Button disabled>Wissensbasis manuell hinzufügen</Button>
        </Center>
    </Paper>;
}

function PrologFileView({ pf }: { pf: PrologFile }) {
    function onFullScreenClicked() {
        // open a new window containing pf.content
        const blob = URL.createObjectURL(new Blob([pf.content], { type: "text/plain" }));
        window.open(blob);
    }

    function onDownloadClicked() {
        const downloadLink = document.createElement('a');
        downloadLink.setAttribute('href', 'data:application/octet-stream;charset=utf-8,' + encodeURIComponent(pf.content));

        const fileName = pf.name.replaceAll("/", "-");
        const fileNameSanitized = fileName.startsWith("-") ? fileName.substring(1) : fileName;

        downloadLink.setAttribute('download', fileNameSanitized);

        // Append the link to the document and click it
        document.body.appendChild(downloadLink);
        downloadLink.click();

        // Remove the temporary link
        document.body.removeChild(downloadLink);
    }

    return <>
        <details>
            <summary>{pf.name}</summary>
            <PrologCodeBlock prologCode={pf.content} h={300} />

            <Center>
                <Flex className={"select-none"}
                    mih={50}
                    gap="xs"
                    justify="center"
                    align="center"
                    direction="row"
                    wrap="wrap">
                    <Button onClick={onDownloadClicked}>💾</Button>
                    <Button onClick={onFullScreenClicked}>Vergrößern</Button>
                    <Button disabled>In Normtext konvertieren 🪄</Button>
                </Flex>
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
        <code className="Prolog">
            {prologCode}
        </code>
    </Code>;
}
