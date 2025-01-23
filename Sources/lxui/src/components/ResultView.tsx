import { Paper, Title, Text, Divider, Button, ScrollArea } from "@mantine/core";
import { CodeView } from "./CodeView";
import Terminal, { ColorMode } from 'react-terminal-ui';
import { useState } from "react";
import { PrologVM } from "@/model/PrologVM";
import { v7 } from "uuid";

export function ResultView({ code, width, prologVM }: {
    code: string,
    width: number,
    prologVM: PrologVM
}) {
    return <Paper shadow="sm"
        p="xl"
        m="sm"
        w={width}>
        <Title>Ergebnisse</Title>
        <Text>Gesamter Prolog-Code:</Text>
        <CodeView code={code} language="prolog" h={300} fileName="result.pl" />
        <Divider my={10} />
        <PrologTerminal prologVM={prologVM} />
    </Paper>;
}

function PrologTerminal({ prologVM }: {
    prologVM: PrologVM
}) {
    enum TerminalState {
        Closed, Minimized, Open, Maximized
    }

    const [terminalState, setTerminalState] = useState<TerminalState>(TerminalState.Open);
    const [terminalLineData, setTerminalLineData] = useState<JSX.Element[]>([]);

    function addLineData(lineData: JSX.Element) {
        setTerminalLineData([...terminalLineData, lineData]);
    }

    function onExecute(terminalInput: string) {
        const query = prologVM.execute(terminalInput);
        const queryJSON = JSON.stringify(query, null, 4);
        addLineData(<>
            <Text key={v7()}>$ {terminalInput}</Text>
            <CodeView
                code={queryJSON}
                language={"json"}
                h={300}
                w={600}
                fileName="output.json"
                showButtons={{
                    magnify: false,
                    download: false,
                    createNormFromSelection: false
                }}/>
        </>);
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
                <ScrollArea h={300}>
                    {terminalLineData}
                </ScrollArea>
            </Terminal>;
        case TerminalState.Maximized:
            return <></>;
    };
}