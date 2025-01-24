import { Paper, Title, Text, Divider, Button, List, Center } from "@mantine/core";
import { CodeView } from "./CodeView";
import Terminal, { ColorMode } from 'react-terminal-ui';
import { useState } from "react";
import { PrologVM } from "@/model/PrologVM";
import { v7 } from "uuid";
import { LandesabgabePerson, LandesabgabeSachverhalt } from "@/model/PrologTemplates";

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
        <details>
            <summary>Gesamter Prolog-Code:</summary>
            <CodeView code={code} language="prolog" h={300} fileName="result.pl" />
        </details>
        <Divider my={10} />
        <PrologResults prologVM={prologVM} />
        <Divider my={10} />
        <Center>
            <PrologTerminal prologVM={prologVM} />
        </Center>
    </Paper>;
}

function PrologResults({ prologVM }: { prologVM: PrologVM }) {
    const registeredSachverhalte = prologVM.getSachverhalte();
    const sachverhalteWithAssociatedPersonIDs: [LandesabgabeSachverhalt, string[]][] =
        registeredSachverhalte.map((s) => [s, s.persons.map((p) => p.personId)]);
    const listItems = sachverhalteWithAssociatedPersonIDs.map(([sachverhalt, personIDs]) => {
        return <>
            <List.Item>{sachverhalt.sacherhaltId}</List.Item>
            <List withPadding listStyleType="disc">
                {
                    personIDs.map((personID) => {
                        const query = `abgabepflichtig(labgg, ${sachverhalt.sacherhaltId}, ${personID}).`;
                        return <DisplayPrologQuery queryString={query} prologVM={prologVM}/>;
                    })
                }
            </List>
        </>
    });

    return <>
        { 
            listItems.length === 0  && <Center>
                <Text>Keine abgabepflichtigen Personen gefunden</Text>
            </Center>
        }

        {
            listItems.length > 0 && <>
                <Text>Abgabepflichtige Personen:</Text>
                <List>{ listItems }</List>
            </>
        }
    </>;
}

function PrologTerminal({ prologVM }: {
    prologVM: PrologVM
}) {
    enum TerminalState {
        Closed, Minimized, Open, Maximized
    }

    const [terminalState, setTerminalState] = useState<TerminalState>(TerminalState.Minimized);
    const [terminalLineData, setTerminalLineData] = useState<JSX.Element[]>([]);

    function addLineData(lineData: JSX.Element) {
        setTerminalLineData([...terminalLineData, lineData]);
    }

    function onExecute(terminalInput: string) {
        addLineData(<>
            <Text key={v7()}>$ {terminalInput}</Text>
            <DisplayPrologQuery
                queryString={terminalInput}
                prologVM={prologVM} />
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

    function renderTerminal() {
        return <Terminal
            key={v7()}
            name="Prolog Terminal"
            colorMode={ColorMode.Dark}
            height={"300"}
            onInput={onExecute}
            redBtnCallback={redButtonCallback}
            yellowBtnCallback={yellowBtnCallback}
            greenBtnCallback={greenButtonCallback} >
            {terminalLineData}
        </Terminal>;
    }

    switch (terminalState) {
        case TerminalState.Closed:
            return <></>;
        case TerminalState.Minimized: {
            function reopenClicked() {
                setTerminalState(TerminalState.Open);
            }
            
            return <Button
                onClick={reopenClicked}
                leftSection={"</>"}>
                    Terminal öffnen
            </Button>;
        }
        case TerminalState.Open:
            return renderTerminal();
        case TerminalState.Maximized:
            return <>
                    {renderTerminal()}
            </>;
    };
}

interface DisplayPrologQueryProps {
    queryString: string,
    prologVM: PrologVM
}

function DisplayPrologQuery({ queryString, prologVM }: DisplayPrologQueryProps) {
    const query: any[] = prologVM.execute(queryString);
    return <DisplayObjectAsJson object={query} />;
}

interface DisplayObjectAsJsonProps {
    object: any,
    indentation?: number
}

function DisplayObjectAsJson({object, indentation = 4}: DisplayObjectAsJsonProps) {
    const json = JSON.stringify(object, null, indentation);
    return <CodeView
        code={json}
        language={"json"}
        h={300}
        fileName="output.json"
        showButtons={{
            magnify: false,
            download: false,
            createNormFromSelection: false,
            copy: false
    }}/>;
}