import { Button, Center, Code, Flex } from "@mantine/core";
import hljs from "highlight.js";
import { useEffect, useId, useState } from "react";
import { G } from "react-router/dist/development/fog-of-war-Ckdfl79L";

export function CodeView({ code, language, h = undefined, fileName = "prolog.pl", showButtons = { download: true, magnify: true, createNormFromSelection: true, copy: true } }: {
    code: string,
    language: string,
    h?: number,
    fileName?: string,
    showButtons?: {
        download: boolean,
        magnify: boolean,
        createNormFromSelection: boolean,
        copy: boolean
    }
}) {
    const codeId = useId();

    useEffect(() => {
        const codeElement = document.getElementById(codeId);

        if (codeElement) {
            hljs.highlightElement(codeElement);
        }
    }, [code]);

    const showFooter = showButtons.download || showButtons.magnify || showButtons.createNormFromSelection;

    // TODO make the "In Norm verwandeln"-Button call an LLM in the Backend and return the correct german law text
    // we will work together on the prompts
    // only sent the selected text
    return <><Code h={h} block>
        <code id={codeId} className={language}>
            {code}
        </code>
    </Code>
        {showFooter && <Center>
            <Flex className={"select-none"}
                mih={50}
                gap="xs"
                justify="center"
                align="center"
                direction="row"
                wrap="wrap">
                { showButtons.copy && <CopyButton text={code}/>}
                { showButtons.download && <DownloadButton text={code} fileName={fileName}/> }
                { showButtons.magnify && <MagnifyButton text={code}/> }
                { showButtons.createNormFromSelection && <Button disabled leftSection={"🪄"}>In Norm verwandeln</Button> }
            </Flex>
        </Center>
        }
    </>;
}

function MagnifyButton({text}: {text: string}) {
    function onFullScreenClicked() {
        // open a new window containing pf.content
        // TODO make this more beautiful
        const blob = URL.createObjectURL(new Blob([text], { type: "text/plain" }));
        window.open(blob);
    }

    return <Button onClick={onFullScreenClicked} leftSection={"💻"}>Vergrößern</Button>;
}

function DownloadButton({text, fileName}: {text: string, fileName: string}) {
    function onDownloadClicked() {
        const downloadLink = document.createElement('a');
        downloadLink.setAttribute('href', 'data:application/octet-stream;charset=utf-8,' + encodeURIComponent(text));

        const fileNameSanitized = fileName.startsWith("-") ? fileName.substring(1) : fileName;

        downloadLink.setAttribute('download', fileNameSanitized);

        // Append the link to the document and click it
        document.body.appendChild(downloadLink);
        downloadLink.click();

        // Remove the temporary link
        document.body.removeChild(downloadLink);
    }

    return <Button onClick={onDownloadClicked} leftSection={"💾"}>Download</Button>;
}

function CopyButton({text}: {text: string}) {
    const copyButtonOriginalText = "Kopieren";
    const copyButtonOriginalEmoji = "📋";
    const copyButtonOriginalColor = "black";

    const [copyButtonText, setCopyButtonText] = useState<string>(copyButtonOriginalText);
    const [copyButtonLeftSection, setCopyButtonLeftSection] = useState<string>(copyButtonOriginalEmoji);
    const [copyButtonColor, setCopyButtonColor] = useState<string>(copyButtonOriginalColor);

    function onCopyClicked() {
        navigator.clipboard.writeText(text);
        setCopyButtonText("Kopiert!");
        setCopyButtonLeftSection("👌");
        setCopyButtonColor("green");

        setTimeout(() => {
            setCopyButtonText(copyButtonOriginalText);
            setCopyButtonLeftSection(copyButtonOriginalEmoji);
            setCopyButtonColor(copyButtonOriginalColor);
        }, 1000);
    }

    return <Button onClick={onCopyClicked} leftSection={copyButtonLeftSection} color={copyButtonColor}>{ copyButtonText }</Button>;
}