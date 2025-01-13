import { Divider, Paper, Title } from '@mantine/core';
import { LandesabgabeHandlung, LandesabgabePerson, LandesabgabeSachverhalt } from '@/model/PrologTemplates';
import { useEffect, useMemo, useState } from "react";
import { Flex, Button, Text } from "@mantine/core";
import { AppState, getLocalStorage } from "../model/AppState";
import { PrologFile, PrologFileType } from "@/model/PrologFileSystem";

import "highlight.js/styles/github.css";

import logo from "../../../../Resources/logo.svg";
import { SachverhaltEditorForm } from '@/components/SachverhaltEditorForm';
import { PrologFilesAccordion } from '@/components/PrologFilesAccordion';
import { ResultView } from '@/components/ResultView';
import { defaultConfig } from '@/config/ServerConfig';

const DOWNLOAD_FILE_DEFAULT_NAME = "Sachverhalt.sv";
export const WIDTH = 550;

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
    downloadLink.setAttribute('download', DOWNLOAD_FILE_DEFAULT_NAME);

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

  return <Flex
    mih={50}
    gap="xs"
    justify="center"
    align="center"
    direction="column"
    wrap="wrap">

    <Title td="underline">Sachverhalts-Editor</Title>
    <Paper shadow="sm"
      p="sm"
      m="sm">
      <Flex className={"select-none"}
        mih={50}
        gap="xs"
        justify="center"
        align="center"
        direction="row"
        wrap="wrap">
        <Button onClick={onDeleteButtonClicked} leftSection={"🗑"}>Löschen</Button>
        <Button onClick={onSaveClicked} leftSection={"💾"}>Speichern</Button>
        <VersionString />
      </Flex>
    </Paper>
    <Divider />
    <AppStateView appState={prologVM} />

    <Text c="dimmed">
      Ein Projekt der Stabsstelle für Digitalisierung Oberösterreich☕
    </Text>
  </Flex>;
}

function VersionString() {
  const [version, setVersion] = useState<string>("");

  useEffect(() => {
    async function d() {
      const versionRequest = await fetch(`${defaultConfig.getServerProtocol()}://${defaultConfig.getServerName()}:${defaultConfig.getServerPort()}/version`, {
        mode: "cors"
      });

      if (!versionRequest.ok) {
        console.error(versionRequest);
        return "Could not connect to server";
      }

      setVersion("Version: " + await versionRequest.text());
    }

    d();
  }, []);

  return <Text c="dimmed">{version}</Text>;
}

/*
* The AppStateView is responsible for:
*  - displaying prolog files, resulting code, and the form view
*  - creating the Prolog from the output
*  - re-creating the page from the prolog VM on page reload
*/
function AppStateView({ appState }: { appState: AppState }) {
  const [code, setCode] = useState<string>();
  const [factBase, setFactBase] = useState<PrologFile[]>(appState.getFactBase());

  console.log("Loaded fact base: ", factBase);

  appState.addFactBaseListener(setFactBase);

  function addFactsFunction(pf: PrologFile) {
    console.log("Adding facts to fact base:", pf);
    appState.addFactBase(pf);
  }

  return <Flex
    mih={50}
    gap="xs"
    justify="flex-start"
    align="top"
    direction="row"
    wrap="wrap">
    <PrologFilesAccordion
      factBase={factBase}
      width={WIDTH} />

    <SachverhaltEditorForm
      addFacts={addFactsFunction}
      initialFactBase={factBase}
      width={WIDTH} />

    <ResultView
      code={code}
      width={WIDTH} />
  </Flex >;
}
