import { PillGroup, Title } from '@mantine/core';
import { LandesabgabeSachverhalt } from '@/model/PrologTemplates';
import { useEffect, useId, useState } from "react";
import { Paper, Flex, Code, Button, Center, ScrollArea } from "@mantine/core";
import { AppState } from "../model/AppState";
import { v4 as uuidv4 } from 'uuid';
import { PrologFile } from "@/model/PrologFileSystem";

import "highlight.js/styles/github.css";
import hljs from "highlight.js";

import logo from "../../../../Resources/logo.svg";
import { PersonForm } from '@/components/PersonForm';
import { SacherhaltEditorForm } from '@/components/SacherhaltEditorForm';
import { Prolog } from 'swipl-wasm';

/**
 * Sets the favicon of the document to the provided SVG data URL.
 *
 * This function creates a new link element with the relationship set to "shortcut icon"
 * and the type set to "image/svg+xml". It then sets the href attribute to the provided
 * SVG data URL and appends the link element to the document's head.
 *
 * @param {string} svgDataURL - The data URL of the SVG to be used as the favicon.
 */
function setFavicon(svgDataURL: string) {
  const link = document.createElement("link");
  link.rel = "shortcut icon";
  link.type = "image/svg+xml";
  link.href = svgDataURL;
  document.head.appendChild(link);
};

function setTitle(title: string) {
  document.title = title;
}

export function HomePage({ prologVM }: { prologVM: AppState }) {
  const sachverhalt = new LandesabgabeSachverhalt();

  function onDeleteButtonClicked() {
    prologVM.reset();
    window.location.reload();
  }

  useEffect(() => {
    setTitle("LXUI");
    setFavicon(logo);
  }, []);

  return <Flex className={"select-none"}
    mih={50}
    gap="xs"
    justify="center"
    align="center"
    direction="column"
    wrap="wrap">
    <Title>Sachverhalts-Editor</Title>
    <MainUI
      sachverhalt={sachverhalt}
      appState={prologVM} />
    <Button onClick={onDeleteButtonClicked}>Löschen 🗑</Button>
  </Flex>;
}

/*
 * This component is responsible for displaying a Sachverhalt
*/
export function MainUI({ sachverhalt, appState }: {
  sachverhalt: LandesabgabeSachverhalt,
  appState: AppState
}) {
  const [code, setCode] = useState<string>();
  const [factBase, setFactBase] = useState<PrologFile[]>(appState.getFactBase());
  const [persons, setPersons] = useState<[string, JSX.Element][]>([generateNewPersonForm()]);

  console.log("Loaded fact base:", factBase);

  appState.addFactBaseListener(setFactBase);

  function addFactsFunction(pf: PrologFile) {
    console.log("Adding facts to fact base:", pf);
    appState.addFactBase(pf);
  }

  function generateNewPersonForm(): [string, JSX.Element] {
    const uuid = uuidv4();
    const personForm = <SacherhaltEditorForm key={uuid}
      sachverhalt={sachverhalt}
      addFacts={addFactsFunction} />;
    return [uuid, personForm];
  }

  useEffect(() => {
    async function f() {
      const result = await appState.evaluate();
      setCode(result);
    }

    f();
  }, [sachverhalt, persons, appState]);

  return <Flex
    mih={50}
    gap="xs"
    justify="flex-start"
    align="center"
    direction="row"
    wrap="wrap">
    <FactBaseView factBase={factBase} />
    <FormView persons={persons} />
    <ResultView code={code} />
  </Flex >;
}

function FactBaseView({ factBase }: { factBase: PrologFile[] }) {
  return <Paper shadow="xs"
    p="xl"
    m="sm">
    <PrologFilesAccordion factBase={factBase} />
  </Paper>;
}

function ResultView({ code }: { code: string | undefined }) {
  return <Paper shadow="xs"
    p="xl"
    m="sm">
    <Code>{code}</Code>
  </Paper>
}

function FormView({ persons }: { persons: [string, JSX.Element][] }) {
  return <Paper shadow="xs"
    p="xl"
    m="sm">
    {persons.map((x) => x[1])}
  </Paper>;
}

function PrologFilesAccordion({ factBase }: { factBase: PrologFile[] }) {
  return factBase.map((x) => <PrologFileView pf={x} />);
}

function PrologFileView({ pf }: { pf: PrologFile }) {
  function onFullScreenClicked() {
    // open a new window containing pf.content
    const blob = URL.createObjectURL(new Blob([pf.content], { type: "text/plain" }));
    window.open(blob);
  }

  return <>
    <details>
      <summary>{pf.name}</summary>
      <Code block>
        <PrologCodeBlock prologCode={pf.content} />
      </Code>

      <Center>
        <Button onClick={onFullScreenClicked}>Vergrößern</Button>
        <Button disabled>In Normtext konvertieren 🪄</Button>
      </Center>
    </details>
  </>;
}

function PrologCodeBlock({ prologCode }: { prologCode: string }) {
  const codeRef = useId();

  useEffect(() => {
    const codeElement = document.getElementById(codeRef);

    if (codeElement) {
      hljs.highlightElement(codeElement);
    }
  }, [prologCode]);

  return <Code>
    <ScrollArea w={300} h={200}>
      <code id={codeRef} className="prolog overflow-x-auto max-w-11">
        {prologCode}
      </code>
    </ScrollArea>
  </Code>
}

