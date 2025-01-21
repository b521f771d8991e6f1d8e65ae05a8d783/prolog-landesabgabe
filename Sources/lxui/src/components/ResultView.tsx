import { Paper, Title, Text, Divider, Button } from "@mantine/core";
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
        <CodeView code={code} language="prolog" h={300} fileName="result.pl" />
        <Divider my={10} />
        <PrologTerminal />
    </Paper>
}

function PrologTerminal({ }: {}) {
    enum TerminalState {
        Closed, Minimized, Open, Maximized
    }

    const [terminalState, setTerminalState] = useState<TerminalState>(TerminalState.Open);
    const [terminalLineData, setTerminalLineData] = useState<JSX.Element[]>([]);

    function onExecute(terminalInput: string) {

    }

    function redButtonCallback() {
        setTerminalState(TerminalState.Closed);
    }

    function yellowBtnCallback() {
        setTerminalState(TerminalState.Minimized);
    }

    function greenButtonCallback() {
        setTerminalState(TerminalState.Maximized);
    }

    switch (terminalState) {
        case TerminalState.Closed:
            return <></>;
        case TerminalState.Minimized: {
            function reopenClicked() {
                setTerminalState(TerminalState.Open);
            }
            return <Button onClick={reopenClicked} leftSection={"</>"}>Terminal öffnen</Button>;
        }
        case TerminalState.Open:
            return <Terminal
                name="Prolog Terminal"
                colorMode={ColorMode.Dark}
                height={"300"}
                onInput={onExecute}
                redBtnCallback={redButtonCallback}
                yellowBtnCallback={yellowBtnCallback}
                greenBtnCallback={greenButtonCallback} >
                {terminalLineData}
            </Terminal>;
        case TerminalState.Maximized:
            return <></>;
    };
}