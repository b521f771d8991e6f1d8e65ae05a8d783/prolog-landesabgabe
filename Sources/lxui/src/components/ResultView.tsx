import { Paper, Code } from "@mantine/core";

export function ResultView({ code }: { code: string | undefined }) {
    return <Paper shadow="xs"
        p="xl"
        m="sm">
        <Code>{code}</Code>
    </Paper>
}