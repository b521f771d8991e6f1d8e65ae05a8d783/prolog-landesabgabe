import { Paper, Code, Title, ScrollArea, Text, Divider } from "@mantine/core";
import { CodeView } from "./CodeView";

export function ResultView({ code, width }: { code: string, width: number }) {
    console.log(code);
    return <Paper shadow="sm"
        p="xl"
        m="sm"
        w={width}>
        <Title>Ergebnisse</Title>
        <Text>Gesamter Prolog-Code:</Text>
        <CodeView code={code} language="prolog" h={300} />
        <Divider my={10} />
    </Paper>
}