import { LandesabgabePerson, LandesabgabeSachverhalt } from "@/model/PrologTemplates";
import { Input, Text, Button, Paper, Center, NumberInput, Flex, Divider } from "@mantine/core";
import { useId, useState } from "react";
import { HandlungForm } from "./HandlungForm";

export function PersonForm({ sachverhalt }: { sachverhalt: LandesabgabeSachverhalt }) {
    const [vorname, setVorname] = useState<string>();
    const [nachname, setNachname] = useState<string>();
    const [alter, setAlter] = useState<number>();
    const [handlungen, setHandlungen] = useState<JSX.Element[]>([]);

    function generateNewHandlungForm() {
        const person = new LandesabgabePerson(sachverhalt, vorname!, nachname!, alter!);
        return <HandlungForm person={person} />;
    }

    function addButtonClicked() {
        setHandlungen([...handlungen, generateNewHandlungForm()]);
        setVorname("");
        setNachname("");
        setAlter(undefined); // somehow, this does not suffice
    }

    return <>
        <Flex
            mih={50}
            gap="xs"
            justify="flex-start"
            align="center"
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

            <Divider my="md" />

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

            <Button
                disabled={vorname === undefined || nachname === undefined || alter === undefined}
                onClick={addButtonClicked}
                mt={"lg"}>
                Person hinzufügen
            </Button>
        </Flex>

        {handlungen}
    </>;
}
