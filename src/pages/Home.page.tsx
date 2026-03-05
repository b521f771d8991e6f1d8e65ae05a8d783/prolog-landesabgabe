import { useEffect, useMemo, useState } from "react";
import {
	Box,
	Button,
	Divider,
	Flex,
	LoadingOverlay,
	Paper,
	SegmentedControl,
	Text,
	Title,
} from "@mantine/core";
import {
	PrologFile,
	PrologFileType,
} from "../util/PrologVM/PrologFileSystem";
import { PrologVM } from "../util/PrologVM/PrologVM";
import { SwiPrologVM } from "../util/PrologVM/SwiPrologVM";

import "highlight.js/styles/github.css";

import { PrologFilesAccordion } from "@/components/knowledge_basis/PrologFilesAccordion";
import { ResultView } from "@/components/result_view/ResultView";
import { SachverhaltEditorForm } from "@/components/sachverhalts_editor/SachverhaltEditorForm";
import { StatisticsView } from "@/components/StatisticsView";
import { VersionString } from "@/components/VersionString";
import { labgg } from "@/corpus";
import logo from "../static/logo.svg";

export type PrologEngine = "swipl" | "scryer";

const DOWNLOAD_FILE_DEFAULT_NAME = "Sachverhalt.sv";
export const WIDTH = 550;

function setFavicon(svgDataURL: string) {
	const link = document.createElement("link");
	link.rel = "shortcut icon";
	link.type = "image/svg+xml";
	link.href = svgDataURL;
	document.head.appendChild(link);
}

function setTitle(title: string) {
	document.title = title;
}

async function initVM(engine: PrologEngine, lawText: string): Promise<PrologVM> {
	if (engine === "scryer") {
		const { ScryerPrologVM } = await import("../util/PrologVM/ScryerPrologVM");
		return ScryerPrologVM.initFromAppState(lawText);
	}
	return SwiPrologVM.initFromAppState(lawText);
}

export function HomePage() {
	const [pvm, setPVM] = useState<PrologVM | null>(null);
	const [engine, setEngine] = useState<PrologEngine>("swipl");
	const [statisticViewOpened, setStatisticViewOpened] = useState<boolean>(false);

	useEffect(() => {
		setPVM(null);
		initVM(engine, labgg).then((vm) => setPVM(vm));
	}, [engine]);

	function onDeleteButtonClicked() {
		window.location.reload();
	}

	function showStatisticsButtonClicked() {
		setStatisticViewOpened(!statisticViewOpened);
	}

	useEffect(() => {
		setTitle("LXUI");
		setFavicon(logo);
	}, []);

	return (
		<Box pos="relative">
			<LoadingOverlay
				visible={pvm === null}
				zIndex={1000}
				overlayProps={{ radius: "sm", blur: 2 }}
			/>
			<Flex
				mih={50}
				gap="xs"
				justify="center"
				align="center"
				direction="column"
				wrap="wrap"
			>
				<Paper shadow="sm" p="sm" m="sm">
					<Flex
						className={"select-none"}
						mih={50}
						gap="xs"
						justify="center"
						align="center"
						direction="row"
						wrap="wrap"
					>
						<SegmentedControl
							value={engine}
							onChange={(v) => setEngine(v as PrologEngine)}
							data={[
								{ label: "SWI-Prolog", value: "swipl" },
								{ label: "Scryer Prolog", value: "scryer" },
							]}
						/>
						<Button onClick={onDeleteButtonClicked} leftSection={"🗑"}>
							Alles löschen
						</Button>
						{statisticViewOpened ? (
							<Button onClick={showStatisticsButtonClicked} leftSection={"❌"}>
								Statistiken ausblenden
							</Button>
						) : (
							<Button
								onClick={showStatisticsButtonClicked}
								leftSection={"📊"}
								disabled
							>
								Statistiken einblenden
							</Button>
						)}
					</Flex>
				</Paper>
				<Divider />

				{statisticViewOpened && (
					<>
						<Paper shadow="sm" p="sm" m="sm">
							<StatisticsView />
						</Paper>
						<Divider />
					</>
				)}

				{pvm && <AppView prologVM={pvm!} />}
				<VersionString />
			</Flex>
		</Box>
	);
}

/*
 * The AppView is responsible for:
 *  - displaying prolog files, resulting code, and the form view
 *  - creating the Prolog from the output
 *  - re-creating the page from the prolog VM on page reload
 */
function AppView({ prologVM }: { prologVM: PrologVM }) {
	const [factBase, setFactFiles] = useState<PrologFile[]>(
		prologVM.getFactBase(),
	);
	const code = useMemo<string>(() => mergeFactFiles(factBase), [factBase]);

	function mergeFactFiles(pf: PrologFile[]) {
		return pf
			.reduce((p, c) => `${p}\n% Filename: ${c.name}\n${c.evaluatedProlog}`, "")
			.substring(1); // substring is used to prevent the first newline from being shown
	}

	function addToFactBase(newFile: PrologFile) {
		setFactFiles([...factBase, newFile]);
	}

	const addedFactFiles = factBase.filter(
		(x) => x.prologFileType === PrologFileType.FACT,
	);
	prologVM.addFactBases(addedFactFiles);

	console.log("Loaded fact base: ", factBase);

	return (
		<Flex
			mih={50}
			gap="xs"
			justify="flex-start"
			align="top"
			direction="row"
			wrap="wrap"
		>
			<PrologFilesAccordion
				factBase={factBase}
				width={WIDTH}
				addToFactBase={addToFactBase}
			/>

			<SachverhaltEditorForm
				factFiles={factBase}
				setFactFiles={setFactFiles}
				width={WIDTH}
			/>

			<ResultView code={code} width={WIDTH} prologVM={prologVM} />
		</Flex>
	);
}
