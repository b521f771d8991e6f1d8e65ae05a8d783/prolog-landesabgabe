import { AddFactFileFunction, PrologFile, PrologFileType } from "@/model/PrologFileSystem";
import { LandesabgabeHandlung, LandesabgabePerson } from "@/model/PrologTemplates";
import { AppState } from "@/model/AppState";
import { Text, Paper, Button, Title, NumberInput, Table, Divider } from "@mantine/core";
import { DateInput } from "@mantine/dates";
import { useState } from "react";
import { v4 as uuidv4 } from 'uuid';

export function PersonForm({ person, addFacts, initialHandlungen }: {
    person: LandesabgabePerson,
    addFacts: AddFactFileFunction,
    initialHandlungen?: LandesabgabeHandlung[]
}) {
    const [handlungen, setHandlungen] = useState<[LandesabgabeHandlung, string, JSX.Element][]>([]);
    const [date, setDate] = useState<Date | null>(null);
    const [gefördert, setGefördert] = useState<number | null>(null);
    const [uniqueFactSetName] = useState<string>(AppState.getUniqueFilename());

    function generateNewHandlungViewer(): [LandesabgabeHandlung, string, JSX.Element] {
        const handlung = new LandesabgabeHandlung(person, date!, gefördert!);
        const uuid = uuidv4();
        const form = <HandlungViewer key={uuid} handlung={handlung} />;
        return [handlung, uuid, form];
    }

    function addButtonClicked() {
        const newHandlungenValue = [...handlungen, generateNewHandlungViewer()]
        setHandlungen(newHandlungenValue);

        const prologFile = new PrologFile(uniqueFactSetName, generateProlog(), handlungen.map((x) => x[0]), PrologFileType.FACT);
        addFacts(prologFile);
    }

    function generateProlog(): string {
        return `${person.sachverhalt.serialize2Prolog()}
            ${person.serialize2Prolog()}
            ${handlungen.reduce((previousValue: string, currentValue: [LandesabgabeHandlung, string, JSX.Element]): string => {
            return `
                ${previousValue}
                ${currentValue[0].serialize2Prolog()}
            `;
        }, "")}`;
    }

    return <Paper shadow="sm"
        p="xl"
        m="sm">
        <Title>Abgabenakt von "{person.vorname}"</Title>
        <PersonDetail person={person} />
        <Divider my="md" />
        <Text size="xs">Geben Sie hier bitte an wie viel Gestein Sie in welchem Zeitraum gefördert haben</Text>
        <DetailTable handlungen={handlungen}
            setDate={setDate}
            setGefördert={setGefördert}
            date={date}
            gefördert={gefördert}
            addButtonClicked={addButtonClicked} />
    </Paper>;
}

function HandlungViewer({ handlung }: { handlung: LandesabgabeHandlung }) {
    return <Table.Tr>
        <Table.Td>{handlung.date.toISOString()}</Table.Td>
        <Table.Td>{handlung.gefördert}</Table.Td>
        <Table.Td>{handlung.einheit}</Table.Td>
    </Table.Tr >;
}

function PersonDetail({ person }: { person: LandesabgabePerson }) {
    return <>
        <Text>Name: {person.vorname}</Text>
        <Text>Vorname: {person.nachname}</Text>
        <Text>Alter: {person.alter}</Text>
    </>
}

function DetailTable({ handlungen, setDate, setGefördert, date, gefördert, addButtonClicked }: {
    handlungen: [LandesabgabeHandlung, string, JSX.Element][],
    setDate: any,
    setGefördert: any,
    date: any,
    gefördert: any,
    addButtonClicked: any
}) {
    return <Table
        stickyHeader
        stickyHeaderOffset={60}
        variant="vertical">
        <TableHeader></TableHeader>
        <HandlungenTableBody
            handlungen={handlungen}
            setDate={setDate}
            setGefördert={setGefördert}
            date={date}
            gefördert={gefördert}
            addButtonClicked={addButtonClicked}>
        </HandlungenTableBody>
    </Table>;
}

function HandlungenTableBody({ handlungen, setDate, setGefördert, date, gefördert, addButtonClicked }: {
    handlungen: [LandesabgabeHandlung, string, JSX.Element][],
    setDate: any,
    setGefördert: any,
    date: any,
    gefördert: any,
    addButtonClicked: any
}) {
    return <Table.Tbody>
        {handlungen.map((x) => x[2])}

        <Table.Tr>
            <Table.Td>
                <DateInput onChange={setDate} />
            </Table.Td>

            <Table.Td>
                <NumberInput onChange={setGefördert} />
            </Table.Td>

            <Table.Td>
                <Button disabled={date === undefined || date === null || gefördert === undefined || gefördert === 0 || gefördert === null}
                    onClick={addButtonClicked}>
                    Eintrag hinzufügen
                </Button>
            </Table.Td>
        </Table.Tr >
    </Table.Tbody>
}

function TableHeader() {
    return <Table.Thead>
        <Table.Tr>
            <Table.Th>Datum</Table.Th>
            <Table.Th>Geförderte Menge</Table.Th>
            {/*<Table.Th>Einheit</Table.Th>*/}
        </Table.Tr>
    </Table.Thead>;
}
