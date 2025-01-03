import { Title } from '@mantine/core';
import { LandesabgabeSachverhalt } from '@/model/PrologTemplates';
import { useEffect, useState } from "react";
import { Paper, Flex, Code, Button } from "@mantine/core";
import { AppState } from "../model/AppState";
import { v4 as uuidv4 } from 'uuid';
import { PrologFile } from "@/model/PrologFileSystem";

import "highlight.js/styles/github.css";

import logo from "../../../../Resources/logo.svg";
import { SacherhaltEditorForm } from '@/components/SacherhaltEditorForm';
import { PrologFilesAccordion } from '@/components/PrologFilesAccordion';
import { ResultView } from '@/components/ResultView';

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
    <PrologFilesAccordion factBase={factBase} />
    <FormView persons={persons} />
    <ResultView code={code} />
  </Flex >;
}

function FormView({ persons }: { persons: [string, JSX.Element][] }) {
  return <Paper shadow="xs"
    p="xl"
    m="sm">
    {persons.map((x) => x[1])}
  </Paper>;
}