import { LandesabgabeHandlung, LandesabgabePerson } from "@/model/prologTemplates";
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

export function HandlungForm({ person }: { person: LandesabgabePerson }) {
    const [handlungen, setHandlungen] = useState<[LandesabgabeHandlung, JSX.Element][]>([]);
    const [date, setDate] = useState<Date | null>(null);
    const [gefördert, setGefördert] = useState<number | null>(null);
    const dateRef = useRef<HTMLInputElement | null>(null);
    const gefördertRef = useRef<HTMLInputElement | null>(null);

    function generateNewHandlungViewer(): [LandesabgabeHandlung, JSX.Element] {
        const handlung = new LandesabgabeHandlung(person, date!, gefördert!);
        return [handlung, <HandlungViewer handlung={handlung} />];
    }

    function addButtonClicked() {
        setHandlungen([...handlungen, generateNewHandlungViewer()]);
        dateRef.current!.innerHTML = "";
        gefördertRef.current!.innerHTML = "";
    }

    function generatePrologButtonClicked() {
        const serializedPrologCode: string = `
            ${person.serialize2Prolog()}
            ${handlungen.reduce((previousValue: string, currentValue: [LandesabgabeHandlung, JSX.Element]): string => {
            return `
                ${previousValue}
                ${currentValue[0].serialize2Prolog()}
            `;
        }, "")}
        `;

        console.log(serializedPrologCode);
    }

    return <Paper
        shadow="xs"
        p="xl"
        m="sm">
        <Title>Abgabenakt von "{person.vorname}"</Title>

        <Text>Name: {person.vorname}</Text>
        <Text>Vorname: {person.nachname}</Text>
        <Text>Alter: {person.alter}</Text>

        <Divider my="md" />

        <Table
            stickyHeader
            stickyHeaderOffset={60}
            variant="vertical">
            <Table.Thead>
                <Table.Tr>
                    <Table.Th>Datum</Table.Th>
                    <Table.Th>Menge</Table.Th>
                    <Table.Th>Einheit</Table.Th>
                </Table.Tr>
            </Table.Thead>

            <Table.Tbody>
                {handlungen.map((x) => x[1])}

                <Table.Tr>
                    <Table.Td>
                        <DateInput
                            ref={dateRef}
                            onChange={setDate} />
                    </Table.Td>

                    <Table.Td>
                        <NumberInput
                            ref={gefördertRef}
                            onChange={setGefördert} />
                    </Table.Td>

                    <Table.Td>
                        <Button
                            disabled={date === undefined || gefördert === undefined}
                            onClick={addButtonClicked}>
                            Eintrag hinzufügen
                        </Button>
                    </Table.Td>
                </Table.Tr >
            </Table.Tbody>
        </Table>

        <Button onClick={generatePrologButtonClicked}>Prolog generieren</Button>
    </Paper>;
}