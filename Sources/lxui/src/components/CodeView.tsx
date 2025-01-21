import { Button, Center, Code, Flex } from "@mantine/core";
import hljs from "highlight.js";
import { useEffect, useId } from "react";

export function CodeView({ code, language, h = 300, fileName = "prolog.pl"}: {
    code: string,
    language: string,
    h: number,
    fileName: string
}) {
    const codeId = useId();

    useEffect(() => {
        const codeElement = document.getElementById(codeId);

        if (codeElement) {
            hljs.highlightElement(codeElement);
        }
    }, [code]);

    function onFullScreenClicked() {
        // open a new window containing pf.content
        // TODO make this more beautiful
        const blob = URL.createObjectURL(new Blob([code], { type: "text/plain" }));
        window.open(blob);
    }

    function onDownloadClicked() {
        const downloadLink = document.createElement('a');
        downloadLink.setAttribute('href', 'data:application/octet-stream;charset=utf-8,' + encodeURIComponent(code));

        const fileNameSanitized = fileName.startsWith("-") ? fileName.substring(1) : fileName;

        downloadLink.setAttribute('download', fileNameSanitized);

        // Append the link to the document and click it
        document.body.appendChild(downloadLink);
        downloadLink.click();

        // Remove the temporary link
        document.body.removeChild(downloadLink);
    }


    // TODO make the "In Norm verwandeln"-Button call an LLM in the Backend and return the correct german law text
    // we will work together on the prompts
    // only sent the selected text
    return <><Code h={h} block>
        <code id={codeId} className={language}>
            {code}
        </code>
        </Code>
        <Center>
            <Flex className={"select-none"}
                mih={50}
                gap="xs"
                justify="center"
                align="center"
                direction="row"
                wrap="wrap">
                <Button onClick={onDownloadClicked} leftSection={"💾"}>Download</Button>
                <Button onClick={onFullScreenClicked} leftSection={"💻"}>Vergrößern</Button>
                <Button disabled leftSection={"🪄"}>In Norm verwandeln</Button>
            </Flex>
        </Center>
    </>;
}