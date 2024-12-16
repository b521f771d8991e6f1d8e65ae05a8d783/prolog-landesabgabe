import { LandesabgabeHandlung, LandesabgabePerson } from "@/model/prologTemplates";
import { Text, Paper, Button, Center, Flex, Title, NumberInput, Table } from "@mantine/core";
import { DateInput } from "@mantine/dates";
import { useState } from "react";

function HandlungViewer({ handlung }: { handlung: LandesabgabeHandlung }) {
    return <Table.Tr>
        <Table.Td>{handlung.date.toISOString()}</Table.Td>
        <Table.Td>{handlung.gefördert}</Table.Td>
        <Table.Td>{handlung.einheit}</Table.Td>
    </Table.Tr >;
}

export function HandlungForm({ person }: { person: LandesabgabePerson }) {
    const [handlungen, setHandlungen] = useState<JSX.Element[]>([]);
    const [date, setDate] = useState<Date | null>();
    const [gefördert, setGefördert] = useState<number | null>();

    function generateNewHandlungViewer() {
        const handlung = new LandesabgabeHandlung(person, date!, gefördert!);
        return <HandlungViewer handlung={handlung} />;
    }

    function addButtonClicked() {
        setHandlungen([...handlungen, generateNewHandlungViewer()]);
    }

    return <Paper shadow="xs" p="xl" m="sm">
        <Title>{person.vorname}</Title>
        <Flex
            mih={50}
            gap="xs"
            justify="flex-start"
            align="flex-start"
            direction="row"
            wrap="wrap">
            <Text>Name: {person.vorname}</Text>
            <Text>Vorname: {person.nachname}</Text>
            <Text>Alter: {person.alter}</Text>
        </Flex>

        <DateInput onChange={setDate} />
        <NumberInput onChange={setGefördert} />

        <Button
            disabled={date === undefined || gefördert === undefined}
            onClick={addButtonClicked}>
            Eintrag hinzufügen
        </Button>

        {(handlungen.length > 0) &&
            <Table stickyHeader stickyHeaderOffset={60} variant="vertical">
                <Table.Thead>
                    <Table.Tr>
                        <Table.Th>Datum</Table.Th>
                        <Table.Th>Menge</Table.Th>
                        <Table.Th>Einheit</Table.Th>
                    </Table.Tr>
                </Table.Thead>

                <Table.Tbody>
                    {handlungen}
                </Table.Tbody>
            </Table>}
    </Paper >;
}