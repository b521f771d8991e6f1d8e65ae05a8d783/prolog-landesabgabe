import { Text, Button, Paper, Title } from "@mantine/core";
import {
	PrologFile,
	PrologFileType,
} from "../../util/PrologVM/PrologFileSystem";
import { SwiPrologVM } from "../../util/PrologVM/SwiPrologVM";
import { FactFile } from "@/components/FactFile";
import { LandesabgabeSachverhalt } from "../../../../Corpus/LabggDefinitions";
import { v7 } from "uuid";

/*
 * This component is used to edit a LandesabgabeSachverhalt.
 * It allows adding multiple Personen to the Sachverhalt.
 */
export function SachverhaltEditorForm({
	factFiles,
	setFactFiles,
	width,
}: {
	factFiles: PrologFile[];
	setFactFiles: (pfs: PrologFile[]) => void;
	width: number;
}) {
	const filteredFacts = factFiles.filter(
		(x) => x.prologFileType === PrologFileType.FACT,
	);

	function addFactFile(
		ff: PrologFile = new PrologFile(
			SwiPrologVM.getUniqueFilename(),
			"",
			new LandesabgabeSachverhalt(),
			PrologFileType.FACT,
		),
	) {
		setFactFiles([...factFiles, ff]);
	}

	function updatePrologFile(pf: PrologFile) {
		const newFactSet = factFiles.filter((x) => x.name !== pf.name);
		newFactSet.push(pf);
		setFactFiles(newFactSet);
	}

	return (
		<Paper shadow="sm" p="xl" m="sm" w={width}>
			<Title>Faktenbasis bearbeiten</Title>
			<Button onClick={() => addFactFile()} leftSection={"➕"}>
				Neue Faktenbasis
			</Button>

			{filteredFacts.length > 0 ? (
				filteredFacts.map((x: PrologFile) => (
					<FactFile key={v7()} prologFile={x} setPrologFile={updatePrologFile} />
				))
			) : (
				<Text>Keine Fakten gefunden</Text>
			)}
		</Paper>
	);
}
