import { Paper, Code, Title } from "@mantine/core";

export function ResultView({ code, width }: { code: string | undefined, width: number }) {
    return <Paper shadow="xs"
        p="xl"
        m="sm"
        w={width}>
        <Title>Ergebnisse</Title>
        <Code>{code}</Code>
    </Paper>
}