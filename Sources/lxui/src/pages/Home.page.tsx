import { Title } from '@mantine/core';
import { LandesabgabeHandlung, LandesabgabePerson, LandesabgabeSachverhalt } from '@/model/PrologTemplates';
import { useEffect, useMemo, useState } from "react";
import { Paper, Flex, Code, Button } from "@mantine/core";
import { AppState, getLocalStorage } from "../model/AppState";
import { v4 as uuidv4 } from 'uuid';
import { PrologFile } from "@/model/PrologFileSystem";

import "highlight.js/styles/github.css";

import logo from "../../../../Resources/logo.svg";
import { SacherhaltEditorForm } from '@/components/SachverhaltEditorForm';
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

/**
 * Represents the home page component of the application.
 *
 * @param {Object} props - The properties object.
 * @param {AppState} props.prologVM - The application state managed by Prolog VM.
 *
 * @returns {JSX.Element} The rendered home page component.
 *
 * @component
 *
 * @example
 * // Usage example:
 * <HomePage prologVM={appState} />
 *
 * @remarks
 * This component sets the page title and favicon on mount, and provides a button
 * to reset the application state and reload the page.
 */
export function HomePage({ prologVM }: { prologVM: AppState }) {
  function onDeleteButtonClicked() {
    prologVM.reset();
    window.location.reload();
  }

  async function onSaveClicked() {
    const storage = getLocalStorage() ?? "[]"; // if there is no object yet created, create an empty array (no object)

    // Create a download link
    const downloadLink = document.createElement('a');
    downloadLink.setAttribute('href', 'data:application/octet-stream;charset=utf-8,' + encodeURIComponent(storage));
    downloadLink.setAttribute('download', 'Sachverhalt.sv');

    // Append the link to the document and click it
    document.body.appendChild(downloadLink);
    downloadLink.click();

    // Remove the temporary link
    document.body.removeChild(downloadLink);
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
    <Title td="underline">Sachverhalts-Editor</Title>
    <AppStateView appState={prologVM} />
    <Button onClick={onDeleteButtonClicked}>Löschen 🗑</Button>
    <Button onClick={onSaveClicked}>Speichern 💾</Button>
  </Flex>;
}

/*
* The AppStateView is responsible for:
*  - displaying prolog files, resulting code, and the form view
*  - creating the Prolog from the output
*  - re-creating the page from the prolog VM on page reload
*/
function AppStateView({ appState }: { appState: AppState }) {
  const [sachverhalt, setSachverhalt] = useState<LandesabgabeSachverhalt>(new LandesabgabeSachverhalt());
  const [code, setCode] = useState<string>();
  const [factBase, setFactBase] = useState<PrologFile[]>(appState.getFactBase());

  // we currently do not have support for multiple Sachverhalte, but that would be possible

  const initialPersons: [LandesabgabePerson, LandesabgabeHandlung[]][] = useMemo(() => {
    const handlungen = appState.getFactBaseContainingHandlung().flatMap((pf) => pf.handlung! as LandesabgabeHandlung[]);

    const personsWithDuplicates = handlungen.map((handlung) => handlung._person as LandesabgabePerson);
    const persons = [...new Set(personsWithDuplicates)];

    return persons.map((person) => [person, handlungen.filter((handlung) => handlung._person === person)]);
  }, [appState]);

  console.log("Loaded fact base:", factBase);
  console.log("Initial persons: ", initialPersons)

  appState.addFactBaseListener(setFactBase);

  function addFactsFunction(pf: PrologFile) {
    console.log("Adding facts to fact base:", pf);
    appState.addFactBase(pf);
  }

  useEffect(() => {
    async function f() {
      const result = await appState.evaluate();
      setCode(result);
    }

    f();
  }, [appState]);

  return <Flex
    mih={50}
    gap="xs"
    justify="flex-start"
    align="center"
    direction="row"
    wrap="wrap">
    <PrologFilesAccordion factBase={factBase} />
    <SacherhaltEditorForm
      addFacts={addFactsFunction}
      sachverhalt={sachverhalt}
      initialPersons={initialPersons} />
    <ResultView code={code} />
  </Flex >;
}
