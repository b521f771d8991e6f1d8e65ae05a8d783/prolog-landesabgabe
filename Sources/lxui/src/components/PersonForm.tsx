import { LandesabgabePerson, LandesabgabeSachverhalt } from "@/model/prologTemplates";
import { Input, Text, Button, Paper, Center, NumberInput, Flex } from "@mantine/core";
import { useState } from "react";

export function PersonForm({ sachverhalt }: { sachverhalt: LandesabgabeSachverhalt }) {
    const [vorname, setVorname] = useState<string>();
    const [nachname, setNachname] = useState<string>();
    const [alter, setAlter] = useState<number>();
    const [handlungen, setHandlungen] = useState<JSX.Element[]>([])

    return <Paper shadow="xs" p="xl" m="sm">
        <Flex
            mih={50}
            gap="xs"
            justify="flex-start"
            align="flex-start"
            direction="row"
            wrap="wrap">
            <Flex
                mih={50}
                justify="flex-start"
                align="flex-start"
                direction="column"
                wrap="wrap">
                <Text mb={4}>Vorname</Text>
                <Input
                    value={vorname}
                    onChange={(event) => setVorname(event.target.value)}
                    placeholder="Geben Sie Ihren Vornamen ein"
                />
            </Flex>

            <Flex
                mih={50}
                justify="flex-start"
                align="flex-start"
                direction="column"
                wrap="wrap">
                <Text mb={4}>Nachname</Text>
                <Input
                    value={nachname}
                    onChange={(event) => setNachname(event.target.value)}
                    placeholder="Geben Sie Ihren Nachnamen ein"
                />
            </Flex>

            <Flex
                mih={50}
                justify="flex-start"
                align="flex-start"
                direction="column"
                wrap="wrap">
                <Text mb={4}>Alter</Text>
                <NumberInput
                    value={alter}
                    onChange={(event) => {
                        if (typeof event === "number") {
                            setAlter(event);
                        }
                        else {
                            console.error("Unknown type");
                        }
                    }}
                    placeholder="Geben Sie Ihren Nachnamen ein"
                />
            </Flex>
        </Flex>
        <Center>
            <Button>Hinzufügen</Button>
        </Center>
    </Paper>;
}
