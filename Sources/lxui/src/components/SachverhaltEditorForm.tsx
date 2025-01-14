import { Text, Button, Paper, Title } from "@mantine/core";
import { useEffect, useMemo, useState } from "react";
import { AddFactFileFunction, PrologFile, PrologFileType } from "@/model/PrologFileSystem";
import { AppState } from "@/model/AppState";
import { FactFile } from "./FactFile";

/*
* This component is used to edit a LandesabgabeSachverhalt.
* It allows adding multiple Personen to the Sachverhalt.
*/
export function SachverhaltEditorForm({ addFacts, initialFactBase, width }: {
    addFacts: AddFactFileFunction,
    initialFactBase: PrologFile[],
    width: number
}) {
    const facts = useMemo<PrologFile[]>(() =>
        initialFactBase.filter((x) => x.prologFileType === PrologFileType.FACT),
        [initialFactBase]);
    const [currentPrologFiles, setCurrentPrologFiles] = useState<PrologFile[]>(facts);

    function addFactBase() {
        setCurrentPrologFiles([
            ...currentPrologFiles,
            new PrologFile(AppState.getUniqueFilename(), "", [], [], PrologFileType.FACT)
        ]);
    }

    return <Paper shadow="sm" p="xl" m="sm" w={width}>
        <Title>Faktenbasis bearbeiten</Title>
        <Button onClick={addFactBase} leftSection={"➕"}>Neue Faktenbasis</Button>

        {currentPrologFiles.length > 0
            ? currentPrologFiles.map((x: PrologFile) => <FactFile prologFile={x} />)
            : <Text>Keine Fakten gefunden</Text>
        }
    </Paper>;
}
