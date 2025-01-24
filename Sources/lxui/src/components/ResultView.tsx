import { Paper, Title, Text, Divider, Button, List, Center } from "@mantine/core";
import { CodeView } from "./CodeView";
import Terminal, { ColorMode } from 'react-terminal-ui';
import { useState } from "react";
import { PrologVM } from "@/model/PrologVM";
import { v7 } from "uuid";
import { LandesabgabeSachverhalt } from "@/model/PrologTemplates";

interface ResultViewProp {
    code: string,
    width: number,
    prologVM: PrologVM
}

export function ResultView({ code, width, prologVM }: ResultViewProp) {
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
    function processPerson(sachverhalt: LandesabgabeSachverhalt, personID: string) {
        const query = `abgabepflichtig(labgg, ${sachverhalt.sacherhaltId}, ${personID}).`;
        return <List.Item key={v7()}>
            <Text>{personID}</Text>
            <DisplayPrologQuery queryString={query} prologVM={prologVM}/>
        </List.Item>;
    }

    const registeredSachverhalte = prologVM.getSachverhalte();
    const sachverhalteWithAssociatedPersonIDs: [LandesabgabeSachverhalt, string[]][] =
        registeredSachverhalte.map((s) => [s, s.persons.map((p) => p.personId)]);
    const listItems = sachverhalteWithAssociatedPersonIDs.map(([sachverhalt, personIDs]) => {
        return <div key={v7()}>
            <List.Item>{sachverhalt.sacherhaltId}</List.Item>
            <List withPadding listStyleType="disc">
                { personIDs.map((personID) => processPerson(sachverhalt, personID)) }
            </List>
        </div>
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
        addLineData(<div key={v7()}>
            <Text key={v7()}>$ {terminalInput}</Text>
            <DisplayPrologQuery
                queryString={terminalInput}
                prologVM={prologVM} />
        </div>);
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