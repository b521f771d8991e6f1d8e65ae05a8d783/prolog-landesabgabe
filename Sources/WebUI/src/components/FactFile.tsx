import { PrologFile } from "../../../LogicKit/src/PrologVM/PrologFileSystem";
import {
	LandesabgabePerson,
	LandesabgabeHandlung,
} from "../../../Corpus/LabggDefinitions";
import {
	Title,
	Text,
	Flex,
	NumberInput,
	Input,
	Button,
	Center,
	Divider,
} from "@mantine/core";
import { useState } from "react";
import { PersonDetailForm } from "./sachverhalts_editor/PersonForm";
import { v7 } from "uuid";
import {
	PrologHandlung,
	PrologPerson,
} from "../../../LogicKit/src/PrologVM/PrologTemplates";

export function FactFile({
	prologFile,
	setPrologFile,
}: {
	prologFile: PrologFile;
	setPrologFile: (pf: PrologFile) => void;
}) {
	const persons = prologFile.sachverhalt!.persons;
	const handlungen = prologFile.sachverhalt!.personsWithAssociatedHandlung;

	const [vorname, setVorname] = useState<string>("");
	const [nachname, setNachname] = useState<string>("");
	const [alter, setAlter] = useState<number>(0);

	function addSovereignPerson(p: LandesabgabePerson) {
		prologFile.sachverhalt!.addSovereignPerson(p);
		setPrologFile(prologFile);
	}

	function addToJoinTable(p: PrologPerson, h: PrologHandlung) {
		prologFile.sachverhalt!.addToJoinTable(p, h);
		setPrologFile(prologFile);
	}

	function addButtonClicked() {
		addSovereignPerson(new LandesabgabePerson(vorname, nachname, alter));
	}

	function renderPersonDetailForm(x: PrologPerson) {
		return (
			<div key={v7()}>
				<PersonDetailForm
					person={x}
					handlungen={handlungen.get(x)!} // ! ist allowed here because we are iterating over the map in the lambda anyway
					addToJoinTable={addToJoinTable}
				/>
				<Divider my="md" />
			</div>
		);
	}

	// TODO remove the Divider following the last item
	return (
		<>
			<Title order={4}>{prologFile.name}</Title>
			<Toolbar
				vorname={vorname}
				setVorname={setVorname}
				nachname={nachname}
				setNachname={setNachname}
				alter={alter}
				setAlter={setAlter}
				addButtonClicked={addButtonClicked}
			/>

			{persons.length > 0 ? (
				persons.map(renderPersonDetailForm)
			) : (
				<Center>
					<Text>Keine Personen gefunden 😥</Text>
				</Center>
			)}
		</>
	);
}

interface ToolbarProps {
	vorname: string;
	setVorname: any;
	nachname: string;
	setNachname: any;
	alter: number;
	setAlter: any;
	addButtonClicked: any;
}

function Toolbar({
	vorname,
	setVorname,
	nachname,
	setNachname,
	alter,
	setAlter,
	addButtonClicked,
}: ToolbarProps) {
	return (
		<Flex
			mih={50}
			gap="xs"
			justify="flex-start"
			align="center"
			direction="row"
			wrap="wrap"
		>
			<Input
				w={100}
				value={vorname}
				onChange={(event) => setVorname(event.target.value)}
				placeholder="Vorname"
			/>
			<Input
				w={100}
				value={nachname}
				onChange={(event) => setNachname(event.target.value)}
				placeholder="Nachname"
			/>
			<NumberInput
				w={80}
				value={alter}
				onChange={(event) => {
					if (typeof event === "number") {
						setAlter(event);
					} else {
						console.error("Unknown type");
					}
				}}
				placeholder="Alter"
			/>

			<Button
				disabled={
					vorname === undefined ||
					nachname === undefined ||
					alter === undefined ||
					vorname === "" ||
					nachname === "" ||
					alter === 0
				}
				onClick={addButtonClicked}
				leftSection={"✨"}
			>
				Person hinzufügen
			</Button>
		</Flex>
	);
}
