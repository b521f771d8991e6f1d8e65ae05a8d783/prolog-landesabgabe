import { PrologFile, PrologFileType } from "@/model/PrologFileSystem";
import { Code, Center, Button, Paper, Title, Flex, Text } from "@mantine/core";
import { CodeView } from "./CodeView";

export function PrologFilesAccordion({ factBase, width }: {
    factBase: PrologFile[],
    width: number
}) {
    const laws = factBase.filter((x) => x.prologFileType === PrologFileType.LAW);
    const mereFacts = factBase.filter((x) => x.prologFileType === PrologFileType.FACT);

    return <Paper shadow="sm"
        p="xl"
        m="sm"
        w={width}>
        <Title>Wissensbasis</Title>

        <Title order={2}>Gesetze</Title>
        {laws.length > 0 && <>
            <Text size="xs">Gesetze werden als Hintergrundinformationen geladen und nicht im Sachverhalt angezeigt</Text>
            {laws.map((x) => <PrologFileView pf={x} key={x.name} />)}
        </>}

        <Center>
            <Flex className={"select-none"}
                mih={50}
                gap="xs"
                justify="center"
                align="center"
                direction="row"
                wrap="wrap">
                <Button leftSection={"⚖️"} disabled>Gesetz aus Bibliothek hinzufügen</Button>
                <Button leftSection={"✏️"} disabled>Gesetze manuell hinzufügen</Button>
            </Flex>
        </Center>

        <Title order={2}>Fakten</Title>
        {mereFacts.length > 0 && <>
            <Text size="xs">Fakten werden im Sachverhalt angezeigt</Text>
            {mereFacts.map((x) => <PrologFileView pf={x} key={x.name} />)}
        </>}

        <Center>
            <Button leftSection={"⚒️"} disabled>Fakten manuell hinzufügen</Button>
        </Center>
    </Paper >;
}

function PrologFileView({ pf }: { pf: PrologFile }) {
    return <>
        <details>
            <summary>{pf.name}</summary>
            <CodeView
                code={pf.evaluatedProlog}
                language="code"
                h={300}
                fileName={pf.name.replaceAll("/", "-")} />
        </details >
    </>;
}
