import React, { useEffect, useState } from "react";
import { v7 } from "uuid";
import {
	Anchor,
	Box,
	Button,
	Center,
	Flex,
	List,
	Paper,
	Text,
	Title,
	Loader,
} from "@mantine/core";
import {
	PrologFile,
	PrologFileType,
} from "../../util/PrologVM/PrologFileSystem";
import { CodeView } from "../CodeView";
import { executePrologFileInPrologVM } from "../../util/PrologVM/PrologVM";

interface PrologFilesAccordionProps {
	factBase: PrologFile[];
	width: number;
	addToFactBase: (newFile: PrologFile) => void;
}

export function PrologFilesAccordion({
	factBase,
	width,
	addToFactBase,
}: PrologFilesAccordionProps) {
	const laws = factBase.filter((x) => x.prologFileType === PrologFileType.LAW);
	const mereFacts = factBase.filter(
		(x) => x.prologFileType === PrologFileType.FACT,
	);

	return (
		<Paper shadow="sm" p="xl" m="sm" w={width}>
			<Title>Wissensbasis</Title>

			<LawView title={"Gesetze"} laws={laws} addToFactBase={addToFactBase} />

			<Title order={2}>Fakten</Title>
			{mereFacts.length > 0 && (
				<>
					<Text size="xs">Fakten werden im Sachverhalt angezeigt</Text>
					{mereFacts.map((x) => (
						<PrologFileView pf={x} key={x.name} />
					))}
				</>
			)}

			<Center>
				<Button leftSection={"⚒️"} mt={"xs"} disabled>
					Fakten manuell hinzufügen
				</Button>
			</Center>
		</Paper>
	);
}

interface LawViewProps {
	title: string;
	laws: PrologFile[];
	addToFactBase: (newFile: PrologFile) => void;
}

function LawView({ title, laws, addToFactBase }: LawViewProps) {
	return (
		<>
			<Title order={2}>{title}</Title>

			{laws.length > 0 && (
				<>
					<Text size="xs">
						Gesetze werden als Hintergrundinformationen geladen und nicht im
						Sachverhalt angezeigt
					</Text>
					{laws.map((x) => (
						<PrologFileView pf={x} key={x.name} />
					))}
				</>
			)}
		</>
	);
}

function PrologFileView({ pf }: { pf: PrologFile }) {
	const [loadingIndicator, setLoadingIndicator] = useState<boolean>(true);
	const [langtitel, setLangtitel] = useState<string>();
	const [kurztitel, setKurztitel] = useState<string>();
	const [link, setLink] = useState<string>();
	const [titel, setTitel] = useState<string>();

	useEffect(() => {
		async function effect() {
			function extract(x: any): string | undefined {
				if (x && x[0] && x[0].X !== undefined) {
					return String(x[0].X);
				} else {
					return undefined;
				}
			}
			const l: string | undefined = extract(
				await executePrologFileInPrologVM(pf, `langtitel(${pf.name}, X).`),
			);
			const k: string | undefined = extract(
				await executePrologFileInPrologVM(pf, `kurztitel(${pf.name}, X).`),
			);
			const u: string | undefined = extract(
				await executePrologFileInPrologVM(pf, `link(${pf.name}, X).`),
			);
			const t: string | undefined = extract(
				await executePrologFileInPrologVM(pf, `titel(${pf.name}, X).`),
			);

			setLangtitel(l);
			setKurztitel(k);
			setLink(u);
			setTitel(t);
			setLoadingIndicator(false);
		}

		effect();
	}, [pf]);

	return (
		<>
			{loadingIndicator && (
				<Center my={10}>
					<Loader color="rgba(0, 0, 0, 1)" />
				</Center>
			)}
			{!loadingIndicator && (
				<details>
					<summary>{titel ?? pf.name}</summary>
					{kurztitel && (
						<Text size="xs">
							<u>Kurztitel:</u> {kurztitel}{" "}
							{link && <Anchor href={link}>(Volltext-Link)</Anchor>}
						</Text>
					)}
					{langtitel && (
						<Text size="xs">
							<u>Langtitel</u>: {langtitel}
						</Text>
					)}
					<CodeView
						code={pf.evaluatedProlog}
						language="code"
						h={300}
						fileName={pf.name.replaceAll("/", "-")}
					/>
				</details>
			)}
		</>
	);
}
