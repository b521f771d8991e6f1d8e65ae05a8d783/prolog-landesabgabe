import { LandesabgabeHandlung, LandesabgabePerson } from "@/model/PrologTemplates";
import { PrologVM } from "@/model/PrologVM";
import { Text, Paper, Button, Center, Flex, Title, NumberInput, Table, Divider } from "@mantine/core";
import { DateInput } from "@mantine/dates";
import { useRef, useState } from "react";

function HandlungViewer({ handlung }: { handlung: LandesabgabeHandlung }) {
    return <Table.Tr>
        <Table.Td>{handlung.date.toISOString()}</Table.Td>
        <Table.Td>{handlung.gefördert}</Table.Td>
        <Table.Td>{handlung.einheit}</Table.Td>
    </Table.Tr >;
}

export function HandlungForm({ person, prologVM }: { person: LandesabgabePerson, prologVM: PrologVM }) {
    const [handlungen, setHandlungen] = useState<[LandesabgabeHandlung, JSX.Element][]>([]); // TODO save this
    const [date, setDate] = useState<Date | null>(null);
    const [gefördert, setGefördert] = useState<number | null>(null);
    const [uniqueFactSetName, setUniqueFactSetName] = useState<string>(PrologVM.getUniqueFilename());

    function generateNewHandlungViewer(): [LandesabgabeHandlung, JSX.Element] {
        const handlung = new LandesabgabeHandlung(person, date!, gefördert!);
        return [handlung, <HandlungViewer handlung={handlung} />];
    }

    function addButtonClicked() {
        setHandlungen([...handlungen, generateNewHandlungViewer()]);

        prologVM.removeFactBaseIfExists(uniqueFactSetName);
        const prolog = generateProlog();
        prologVM.addFactBase({
            name: uniqueFactSetName,
            content: prolog
        });
    }

    function generateProlog(): string {
        return `${person.sachverhalt.serialize2Prolog()}
            ${person.serialize2Prolog()}
            ${handlungen.reduce((previousValue: string, currentValue: [LandesabgabeHandlung, JSX.Element]): string => {
            return `
                ${previousValue}
                ${currentValue[0].serialize2Prolog()}
            `;
        }, "")}`;
    }

    return <Paper shadow="xs"
        p="xl"
        m="sm">
        <Title>
            Abgabenakt von "{person.vorname}"
        </Title>

        <PersonDetail person={person} />

        <Divider my="md" />

        <DetailTable handlungen={handlungen}
            setDate={setDate}
            setGefördert={setGefördert}
            date={date}
            gefördert={gefördert}
            addButtonClicked={addButtonClicked} />
    </Paper>;
}

function PersonDetail({ person }: { person: LandesabgabePerson }) {
    return <>
        <Text>Name: {person.vorname}</Text>
        <Text>Vorname: {person.nachname}</Text>
        <Text>Alter: {person.alter}</Text>
    </>;
}

function DetailTable({ handlungen, setDate, setGefördert, date, gefördert, addButtonClicked }: {
    handlungen: [LandesabgabeHandlung, JSX.Element][],
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
    handlungen: [LandesabgabeHandlung, JSX.Element][],
    setDate: any,
    setGefördert: any,
    date: any,
    gefördert: any,
    addButtonClicked: any
}) {
    return <Table.Tbody>
        {handlungen.map((x) => x[1])}

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
            <Table.Th>Menge</Table.Th>
            <Table.Th>Einheit</Table.Th>
        </Table.Tr>
    </Table.Thead>;
}
