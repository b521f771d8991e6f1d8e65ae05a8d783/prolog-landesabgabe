import { Paper, Title, Text, Divider } from "@mantine/core";
import { CodeView } from "./CodeView";
import Terminal, { ColorMode } from 'react-terminal-ui';
import { useId, useRef, useState } from "react";

export function ResultView({ code, width }: { code: string, width: number }) {
    console.log(code);
    return <Paper shadow="sm"
        p="xl"
        m="sm"
        w={width}>
        <Title>Ergebnisse</Title>
        <Text>Gesamter Prolog-Code:</Text>
        <CodeView code={code} language="prolog" h={300} />
        <Divider my={10} />
        <PrologTerminal />
    </Paper>
}

function PrologTerminal({ }: {}) {
    const [terminalLineData, setTerminalLineData] = useState<JSX.Element[]>([]);

    function onExecute(terminalInput: string) {

    }

    function redButtonCallback() {

    }

    function yellowBtnCallback() {

    }

    function greenButtonCallback() {

    }

    return <Terminal
        name="Prolog Terminal"
        colorMode={ColorMode.Dark}
        height={"300"}
        onInput={onExecute}
        redBtnCallback={redButtonCallback}
        yellowBtnCallback={yellowBtnCallback}
        greenBtnCallback={greenButtonCallback}>
        {terminalLineData}
    </ Terminal >
}