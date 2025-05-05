import {
	Paper,
	Title,
	Text,
	Divider,
	Button,
	List,
	Center,
} from "@mantine/core";
import { CodeView } from "../CodeView";
import Terminal, { ColorMode } from "react-terminal-ui";
import { useState } from "react";
import {
	PrologVM,
	SwiPrologVM,
} from "../../../../LogicKit/src/PrologVM/PrologVM";
import { v7 } from "uuid";
import {
	LandesabgabePerson,
	LandesabgabeSachverhalt,
} from "../../../../LogicKit/src/PrologVM/PrologTemplates";
import { PrologFile } from "../../../../LogicKit/src/PrologVM/PrologFileSystem";
import { isPrologFalse } from "../../../../LogicKit/src/PrologVM/PrologUtilities";

export function ResultView({
	code,
	width,
	prologVM,
}: {
	code: string;
	width: number;
	prologVM: PrologVM;
}) {
	return (
		<Paper shadow="sm" p="xl" m="sm" w={width}>
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
		</Paper>
	);
}

function PersonDetail({
	sachverhalt,
	person,
	prologVM,
}: {
	sachverhalt: LandesabgabeSachverhalt;
	person: LandesabgabePerson;
	prologVM: PrologVM;
}) {
	function getGesteinIdFromPersonId(
		prologVM: PrologVM,
		sachverhalt: LandesabgabeSachverhalt,
		person: LandesabgabePerson,
	) {
		const objektResult = prologVM.executeQueryAndEvaluate<string>(
			`objekt(${sachverhalt.sacherhaltId}, ${person.personId}, bergbau(gewinnen, obertags, mineralische_rohstoffe), Y)`,
			"Y",
		);
		return objektResult;
	}

	function getAmountOfMoneyOwedFromGesteinId(
		prologVM: PrologVM,
		objektResultList: unknown[],
	) {
		const höheResult = prologVM.executeQueryAndEvaluate<number>(
			`abgabe_hoehe(labgg, ${objektResultList[0]}, Y)`,
			"Y",
		);
		console.assert(höheResult.length == 1);
		return höheResult;
	}

	console.log(prologVM.getFacts().map((x) => x.evaluatedProlog));
	const objektResultList = getGesteinIdFromPersonId(
		prologVM,
		sachverhalt,
		person,
	);
	const höheResultList = getAmountOfMoneyOwedFromGesteinId(
		prologVM,
		objektResultList,
	);

	return (
		<List.Item key={v7()}>
			{person.vorname} {person.nachname} schuldet{" "}
			{(höheResultList[0] as number).toFixed(2)}€
		</List.Item>
	);
}

function PrologResults({ prologVM }: { prologVM: PrologVM }) {
	function processPerson(
		sachverhalt: LandesabgabeSachverhalt,
		personID: string,
	) {
		const query = `abgabepflichtig(labgg, ${sachverhalt.sacherhaltId}, ${personID}).`;
		const queryResult = prologVM.execute(query);
		const person = prologVM.lookupPersonByID(personID)!;

		return isPrologFalse(queryResult) ? undefined : (
			<PersonDetail
				key={v7()}
				sachverhalt={sachverhalt}
				person={person}
				prologVM={prologVM}
			/>
		);
	}

	const registeredSachverhalte = prologVM.getFacts();
	const sachverhalteWithAssociatedPersonIDs: [PrologFile, string[]][] =
		registeredSachverhalte.map((pf) => [
			pf,
			pf.sachverhalt!.persons.map((p) => p.personId),
		]);

	const listItems = sachverhalteWithAssociatedPersonIDs.map(
		([prologFile, personIDs]) => {
			const personsSubjectToLandesabgabe = personIDs
				.map((personID) => processPerson(prologFile.sachverhalt!, personID))
				.filter((x): x is JSX.Element => !!x);

			return (
				<div key={v7()}>
					{personsSubjectToLandesabgabe.length > 0 && (
						<>
							<List.Item>
								In Datei "<i>{prologFile.name}</i>":
							</List.Item>
							<List withPadding listStyleType="disc" key={v7()}>
								{personsSubjectToLandesabgabe}
							</List>
						</>
					)}
				</div>
			);
		},
	);

	return (
		<>
			{listItems.length === 0 && (
				<Center>
					<Text>Keine abgabepflichtigen Personen gefunden</Text>
				</Center>
			)}

			{listItems.length > 0 && (
				<details open>
					<summary>Abgabepflichtige Personen:</summary>
					<List>{listItems}</List>
				</details>
			)}
		</>
	);
}

function PrologTerminal({ prologVM }: { prologVM: PrologVM }) {
	enum TerminalState {
		Closed,
		Minimized,
		Open,
		Maximized,
	}

	const [terminalState, setTerminalState] = useState<TerminalState>(
		TerminalState.Minimized,
	);
	const [terminalLineData, setTerminalLineData] = useState<JSX.Element[]>([]);

	function addLineData(lineData: JSX.Element) {
		setTerminalLineData([...terminalLineData, lineData]);
	}

	function onExecute(terminalInput: string) {
		addLineData(
			<div key={v7()}>
				<Text key={v7()}>$ {terminalInput}</Text>
				<DisplayPrologQuery queryString={terminalInput} prologVM={prologVM} />
			</div>,
		);
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
		return (
			<Terminal
				key={v7()}
				name="Prolog Terminal"
				colorMode={ColorMode.Dark}
				height={"300"}
				onInput={onExecute}
				redBtnCallback={redButtonCallback}
				yellowBtnCallback={yellowBtnCallback}
				greenBtnCallback={greenButtonCallback}
			>
				{terminalLineData}
			</Terminal>
		);
	}

	switch (terminalState) {
		case TerminalState.Closed:
			return <></>;
		case TerminalState.Minimized: {
			function reopenClicked() {
				setTerminalState(TerminalState.Open);
			}

			return (
				<Button onClick={reopenClicked} leftSection={"</>"}>
					Terminal öffnen
				</Button>
			);
		}
		case TerminalState.Open:
			return renderTerminal();
		case TerminalState.Maximized:
			return <>{renderTerminal()}</>;
	}
}

function DisplayPrologQuery({
	queryString,
	prologVM,
}: {
	queryString: string;
	prologVM: PrologVM;
}) {
	const query: any[] = prologVM.execute(queryString);
	return <DisplayObjectAsJson object={query} />;
}

interface DisplayObjectAsJsonProps {
	object: any;
	indentation?: number;
}

function DisplayObjectAsJson({
	object,
	indentation = 4,
}: DisplayObjectAsJsonProps) {
	const json = JSON.stringify(object, null, indentation);
	return (
		<CodeView
			code={json}
			language={"json"}
			h={300}
			fileName="output.json"
			showButtons={{
				magnify: false,
				download: false,
				createNormFromSelection: false,
				copy: false,
			}}
		/>
	);
}
