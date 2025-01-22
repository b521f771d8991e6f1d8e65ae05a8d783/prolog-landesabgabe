import { Divider, Paper, Title } from '@mantine/core';
import { useEffect, useMemo, useState } from "react";
import { Flex, Button, Text } from "@mantine/core";
import { PrologVM, getLocalStorage } from "../model/PrologVM";
import { PrologFile } from "@/model/PrologFileSystem";

import "highlight.js/styles/github.css";

import logo from "../static/logo.svg";
import { SachverhaltEditorForm } from '@/components/SachverhaltEditorForm';
import { PrologFilesAccordion } from '@/components/PrologFilesAccordion';
import { ResultView } from '@/components/ResultView';
import { defaultConfig } from '@/config/ServerConfig';
import { StatisticsView } from '@/components/StatisticsView';

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
 * @param {PrologVM} props.prologVM - The application state managed by Prolog VM.
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
export function HomePage({ prologVM }: { prologVM: PrologVM }) {
  const [statisticViewOpened, setStatisticViewOpened] = useState<boolean>(false);

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

  function showStatisticsButtonClicked() {
    setStatisticViewOpened(!statisticViewOpened);
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
        <Button leftSection={"📅"} disabled>Historie</Button>
        <Button onClick={onDeleteButtonClicked} leftSection={"🗑"}>Alles löschen</Button>
        <Button onClick={onSaveClicked} leftSection={"💾"}>Speichern</Button>
        <Button leftSection={"⚡"} disabled>Laden</Button>
        <Button leftSection={"🔐"} disabled>Login</Button>
        {
          statisticViewOpened
            ? <Button onClick={showStatisticsButtonClicked} leftSection={"❌"}>Statistiken ausblenden</Button>
            : <Button onClick={showStatisticsButtonClicked} leftSection={"📊"} disabled>Statistiken einblenden</Button>
        }
      </Flex>
    </Paper>
    <Divider />

    {statisticViewOpened && <>
      <Paper shadow="sm"
        p="sm"
        m="sm">
        <StatisticsView />
      </Paper>
      <Divider />
    </>}

    <AppStateView appState={prologVM} />

    <Text c="dimmed">
      Ein Projekt der Stabsstelle für Digitalisierung Oberösterreich☕
    </Text>
    <VersionString />
  </Flex>;
}

function VersionString() {
  const [version, setVersion] = useState<JSX.Element>(<></>);

  useEffect(() => {
    async function d() {
      const versionRequest = await fetch(`${defaultConfig.getServerProtocol()}://${defaultConfig.getServerName()}:${defaultConfig.getServerPort()}/version`, {
        mode: "cors"
      });

      if (!versionRequest.ok) {
        console.error(versionRequest);
        setVersion(<Text c="red">Could not connect to server</Text>);
      }

      setVersion(<Text c="dimmed">Version: {await versionRequest.text()}</Text >);
    }

    d();
  }, []);

  return version;
}

/*
* The AppStateView is responsible for:
*  - displaying prolog files, resulting code, and the form view
*  - creating the Prolog from the output
*  - re-creating the page from the prolog VM on page reload
*/
function AppStateView({ appState }: {
  appState: PrologVM
}) {
  function mergeFactFiles(pf: PrologFile[]) {
    return factFiles.reduce((p, c) => `${p}\n% Filename: ${c.name}\n${c.evaluatedProlog}`, "");
  }

  const [factFiles, setFactFiles] = useState<PrologFile[]>(appState.getFactBase());
  const code = useMemo<string>(() => mergeFactFiles(factFiles), [factFiles]);

  useEffect(() => {
    // update the App State
  }, [factFiles]);

  console.log("Loaded fact base: ", factFiles);

  return <Flex
    mih={50}
    gap="xs"
    justify="flex-start"
    align="top"
    direction="row"
    wrap="wrap">
    <PrologFilesAccordion
      factBase={factFiles}
      width={WIDTH} />

    <SachverhaltEditorForm
      factFiles={factFiles}
      setFactFiles={setFactFiles}
      width={WIDTH} />

    <ResultView
      code={code}
      width={WIDTH} />
  </Flex >;
}
