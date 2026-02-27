import { useEffect, useMemo, useState } from "react";
import {
	Box,
	Button,
	Divider,
	Flex,
	LoadingOverlay,
	Paper,
	Text,
	Title,
} from "@mantine/core";
import {
	PrologFile,
	PrologFileType,
} from "../util/PrologVM/PrologFileSystem";
import { SwiPrologVM } from "../util/PrologVM/SwiPrologVM";

import "highlight.js/styles/github.css";

import { PrologFilesAccordion } from "@/components/knowledge_basis/PrologFilesAccordion";
import { ResultView } from "@/components/result_view/ResultView";
import { SachverhaltEditorForm } from "@/components/sachverhalts_editor/SachverhaltEditorForm";
import { StatisticsView } from "@/components/StatisticsView";
import { VersionString } from "@/components/VersionString";
import { useGetWebServerString } from "@/util/BackendQueryProvider";
import logo from "../static/logo.svg";

const DOWNLOAD_FILE_DEFAULT_NAME = "Sachverhalt.sv";
export const WIDTH = 550;

/**
 * Sets the favicon of the document to the provided SVG data URL.
 *
 * This function creates a new link element with the relationship set to "shortcut icon"
 * and the type set to "image/svg+xml". It then sets the href attribute to the provided
 * SVG data URL and appends the link element to the document's head.
 *
 * @param {string} svgDataURL - The data URL of the SVG to be used as the favicon.
 */
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

/**
 * Represents the home page component of the application.
 *
 * @param {Object} props - The properties object.
 * @param {SwiPrologVM} props.prologVM - The application state managed by Prolog VM.
 *
 * @returns {JSX.Element} The rendered home page component.
 *
 * @component
 *
 * @example
 * // Usage example:
 * <HomePage prologVM={appState} />
 *
 * @remarks
 * This component sets the page title and favicon on mount, and provides a button
 * to reset the application state and reload the page.
 */
export function HomePage() {
	const [pvm, setPVM] = useState<SwiPrologVM | null>(null);
	const [statisticViewOpened, setStatisticViewOpened] = useState<boolean>(false);
	const kurztitel = "labgg"; // TODO @Alexander change to array loaded from .env and don't forget to change kurztitel from string to array
	const { data, error, isLoading, isError, isSuccess } = useGetWebServerString(
		"private/fetch-law?kurztitel=" + kurztitel,
	);

	useEffect(() => {
		if (isSuccess) {
			if (pvm === null) {
				SwiPrologVM.initFromAppState(data!).then((pvm) => setPVM(() => pvm));
			}
		}

		if (isError) {
			// FIXME setLoadError(error!.message);
		}
	}, [isSuccess, isError]);

	function onDeleteButtonClicked() {
		window.location.reload();
	}

	async function onSaveClicked() {
		/*
    const storage = getLocalStorage() ?? "[]"; // if there is no object yet created, create an empty array (no object)

    // Create a download link
    const downloadLink = document.createElement('a');
    downloadLink.setAttribute('href', 'data:application/octet-stream;charset=utf-8,' + encodeURIComponent(storage));
    downloadLink.setAttribute('download', DOWNLOAD_FILE_DEFAULT_NAME);

    // Append the link to the document and click it
    document.body.appendChild(downloadLink);
    downloadLink.click();

    // Remove the temporary link
    document.body.removeChild(downloadLink);
    */
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
						<Button leftSection={"📅"} disabled>
							Historie
						</Button>
						<Button onClick={onDeleteButtonClicked} leftSection={"🗑"}>
							Alles löschen
						</Button>
						<Button onClick={onSaveClicked} leftSection={"💾"} disabled>
							Speichern
						</Button>
						<Button leftSection={"⚡"} disabled>
							Laden
						</Button>
						<Button leftSection={"🔐"} disabled>
							Login
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
function AppView({ prologVM }: { prologVM: SwiPrologVM }) {
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
