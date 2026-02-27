import {
	LandesabgabeHandlung,
	LandesabgabePerson,
	LandesabgabeSachverhalt,
} from "../../../../Corpus/LabggDefinitions";
import {
	Text,
	Paper,
	Button,
	Title,
	NumberInput,
	Table,
	Divider,
} from "@mantine/core";
import { DateInput } from "@mantine/dates";
import { useState } from "react";
import { v7 } from "uuid";
import {
	PrologHandlung,
	PrologPerson,
} from "../../util/PrologVM/PrologTemplates";

export function PersonDetailForm({
	person,
	handlungen,
	addToJoinTable,
}: {
	person: PrologPerson;
	handlungen: PrologHandlung[];
	addToJoinTable: (p: PrologPerson, h: PrologHandlung) => void;
}) {
	const [date, setDate] = useState<Date>(new Date(Date.now()));
	const [gefördert, setGefördert] = useState<number>(0);

	function addButtonClicked() {
		addToJoinTable(person, new LandesabgabeHandlung(date, gefördert));
	}

	return (
		<Paper shadow="sm" p="xl" m="sm">
			<Title order={5}>Abgabenakt von "{person.vorname}"</Title>
			<PersonDetail person={person} />
			<Divider my="md" />
			<Text size="xs">
				Geben Sie hier bitte an wie viel Gestein Sie in welchem Zeitraum gefördert
				haben
			</Text>
			<DetailTable
				handlungen={handlungen}
				setDate={setDate}
				setGefördert={setGefördert}
				date={date}
				gefördert={gefördert}
				addButtonClicked={addButtonClicked}
			/>
		</Paper>
	);
}

function PersonDetail({ person }: { person: PrologPerson }) {
	return (
		<>
			<Text>Name: {person.nachname}</Text>
			<Text>Vorname: {person.vorname}</Text>
			<Text>Alter: {person.alter}</Text>
		</>
	);
}

function DetailTable({
	handlungen,
	setDate,
	setGefördert,
	date,
	gefördert,
	addButtonClicked,
}: {
	handlungen: PrologHandlung[];
	setDate: any;
	setGefördert: any;
	date: any;
	gefördert: any;
	addButtonClicked: any;
}) {
	return (
		<Table stickyHeader stickyHeaderOffset={60} variant="vertical">
			<TableHeader></TableHeader>
			<HandlungenTableBody
				handlungen={handlungen}
				setDate={setDate}
				setGefördert={setGefördert}
				date={date}
				gefördert={gefördert}
				addButtonClicked={addButtonClicked}
			></HandlungenTableBody>
		</Table>
	);
}

function HandlungenTableBody({
	handlungen,
	setDate,
	setGefördert,
	date,
	gefördert,
	addButtonClicked,
}: {
	handlungen: PrologHandlung[];
	setDate: any;
	setGefördert: any;
	date: any;
	gefördert: any;
	addButtonClicked: any;
}) {
	return (
		<Table.Tbody>
			{handlungen.map((x) => (
				<HandlungViewer key={v7()} handlung={x} />
			))}

			<Table.Tr>
				<Table.Td>
					<DateInput onChange={setDate} />
				</Table.Td>

				<Table.Td>
					<NumberInput onChange={setGefördert} />
				</Table.Td>

				<Table.Td>
					<Button
						disabled={
							date === undefined ||
							date === null ||
							gefördert === undefined ||
							gefördert === 0 ||
							gefördert === null
						}
						onClick={addButtonClicked}
						leftSection={"✍️"}
					>
						Eintrag hinzufügen
					</Button>
				</Table.Td>
			</Table.Tr>
		</Table.Tbody>
	);
}

function TableHeader() {
	return (
		<Table.Thead>
			<Table.Tr>
				<Table.Th>Datum</Table.Th>
				<Table.Th>Geförderte Menge</Table.Th>
				<Table.Th>Einheit</Table.Th>
			</Table.Tr>
		</Table.Thead>
	);
}

function HandlungViewer({ handlung }: { handlung: PrologHandlung }) {
	return (
		<Table.Tr>
			<Table.Td>
				{handlung.date.getDay()}.{handlung.date.getUTCMonth()}.
				{handlung.date.getFullYear()}
			</Table.Td>
			{handlung.visualization}
		</Table.Tr>
	);
}
