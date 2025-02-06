import { useEffect, useId, useRef, useState } from 'react';
import hljs from 'highlight.js';
import { Box, Button, Center, Code, Flex, LoadingOverlay } from '@mantine/core';
import { useDisclosure } from '@mantine/hooks';
import { TaskResultFetchingErrorView } from './TaskResultFetchingErrorView';
import { TaskResultView } from './TaskResultView';
import { TaskStartRequest } from './TaskStartRequest';

export function CodeView({
  code,
  language,
  h = undefined,
  fileName = 'prolog.pl',
  showButtons = { download: true, magnify: true, createNormFromSelection: true, copy: true },
}: {
  code: string;
  language: string;
  h?: number;
  fileName?: string;
  showButtons?: {
    download: boolean;
    magnify: boolean;
    createNormFromSelection: boolean;
    copy: boolean;
  };
}) {
  const codeId = useId();
  const codeElement = document.getElementById(codeId);
  const [selection, setSelection] = useState<string>('');
  const [norms, setNorms] = useState<string[]>([]);
  const [taskId, setTaskId] = useState<string | null>(null);
  const [isTaskError, setIsTaskError] = useState<boolean>(false);
  const [isTaskRequestInProgress, setIsTaskRequestInProgress] = useState<boolean>(false);
  const [visible, { toggle }] = useDisclosure(false);

  useEffect(() => {
    if (codeElement) {
      if (codeElement.hasAttribute('data-highlighted')) {
        codeElement.removeAttribute('data-highlighted');
      }

      hljs.highlightElement(codeElement);
    }
    const handleMouseUp = () => {
      const selection = window.getSelection();
      if (selection) {
        const selectedText = selection.toString();
        if (code.includes(selectedText)) {
          setSelection(selectedText);
        } else {
          setSelection('');
        }
      }
    };

    document.addEventListener('mouseup', handleMouseUp);

    return () => {
      document.removeEventListener('mouseup', handleMouseUp);
    };
  }, [code]);

  const onFullScreenClicked = (): void => {
    // open a new window containing pf.content
    // TODO make this more beautiful
    const blob = URL.createObjectURL(new Blob([code], { type: 'text/plain' }));
    window.open(blob);
  };

  const onDownloadClicked = (): void => {
    const downloadLink = document.createElement('a');
    downloadLink.setAttribute(
      'href',
      'data:application/octet-stream;charset=utf-8,' + encodeURIComponent(code)
    );

    const fileNameSanitized = fileName.startsWith('-') ? fileName.substring(1) : fileName;

    downloadLink.setAttribute('download', fileNameSanitized);

    // Append the link to the document and click it
    document.body.appendChild(downloadLink);
    downloadLink.click();

    // Remove the temporary link
    document.body.removeChild(downloadLink);
  };

  const onTransformToNormClicked = (): void => {
    setTaskId(() => null);
    setIsTaskError(() => false);
    setIsTaskRequestInProgress(true);
  };

  const addNorm = (norm: string) => {
    norms.push(norm);
    setNorms(() => norms);
  };

  const enableNormButton = (): boolean => {
    return selection.length > 0 && code.includes(selection);
  };

  const updateTaskId = (taskId: string) => {
    setIsTaskRequestInProgress(() => false);
    setIsTaskError(() => false);
    setTaskId(() => taskId);
  };

  const showFooter =
    showButtons.download || showButtons.magnify || showButtons.createNormFromSelection;

  // TODO make the "In Norm verwandeln"-Button call an LLM in the Backend and return the correct german law text
  // we will work together on the prompts
  // only sent the selected text
  return (
    <>
      <Code h={h} block>
        <code id={codeId} className={language}>
          {code}
        </code>
      </Code>
      {showFooter && (
        <Center>
          <Flex
            className={'select-none'}
            mih={50}
            gap="xs"
            justify="center"
            align="center"
            direction="row"
            wrap="wrap"
          >
            {showButtons.copy && <CopyButton text={code} />}
            {showButtons.download && <DownloadButton text={code} fileName={fileName} />}
            {showButtons.magnify && <MagnifyButton text={code} />}
            <Button
              disabled={false && !enableNormButton()}
              onClick={onTransformToNormClicked}
              leftSection={'🪄'}
            >
              In Norm verwandeln
            </Button>
          </Flex>
            <Box pos="relative">
              <LoadingOverlay
                visible={visible}
                zIndex={1000}
                overlayProps={{ radius: 'sm', blur: 2 }}
              />
              {taskId !== null && <TaskResultView taskId={taskId} addNorm={addNorm} />}
              {isTaskRequestInProgress && (
                <TaskStartRequest selection={selection} setTaskId={updateTaskId} />
              )}
              {isTaskError && <TaskResultFetchingErrorView />}
            </Box>
        </Center>
      )}
    </>
  );
}

/**
 * A button component that opens a new window displaying the provided text content.
 *
 * @param {Object} props - The properties object.
 * @param {string} props.text - The text content to be displayed in the new window.
 *
 * @returns {JSX.Element} The rendered button component.
 */
function MagnifyButton({ text }: { text: string }) {
  function onFullScreenClicked() {
    // open a new window containing pf.content
    // TODO make this more beautiful
    const blob = URL.createObjectURL(new Blob([text], { type: 'text/plain' }));
    window.open(blob);
  }

  return (
    <Button onClick={onFullScreenClicked} leftSection={'💻'}>
      Vergrößern
    </Button>
  );
}

/**
 * A button component that triggers the download of a text file when clicked.
 *
 * @param {Object} props - The properties object.
 * @param {string} props.text - The text content to be downloaded.
 * @param {string} props.fileName - The name of the file to be downloaded.
 *
 * @returns {JSX.Element} A button element that initiates the download.
 */
function DownloadButton({ text, fileName }: { text: string; fileName: string }) {
  function onDownloadClicked() {
    const downloadLink = document.createElement('a');
    downloadLink.setAttribute(
      'href',
      'data:application/octet-stream;charset=utf-8,' + encodeURIComponent(text)
    );

    const fileNameSanitized = fileName.startsWith('-') ? fileName.substring(1) : fileName;

    downloadLink.setAttribute('download', fileNameSanitized);

    // Append the link to the document and click it
    document.body.appendChild(downloadLink);
    downloadLink.click();

    // Remove the temporary link
    document.body.removeChild(downloadLink);
  }

  return (
    <Button onClick={onDownloadClicked} leftSection={'💾'}>
      Download
    </Button>
  );
}

/**
 * A button component that copies the provided text to the clipboard when clicked.
 * The button's text, left section, and color change temporarily to indicate the copy action.
 *
 * @param {Object} props - The properties object.
 * @param {string} props.text - The text to be copied to the clipboard.
 *
 * @returns {JSX.Element} The rendered button component.
 */
function CopyButton({ text }: { text: string }) {
  const copyButtonOriginalText = 'Kopieren';
  const copyButtonOriginalEmoji = '📋';
  const copyButtonOriginalColor = 'black';

  const [copyButtonText, setCopyButtonText] = useState<string>(copyButtonOriginalText);
  const [copyButtonLeftSection, setCopyButtonLeftSection] =
    useState<string>(copyButtonOriginalEmoji);
  const [copyButtonColor, setCopyButtonColor] = useState<string>(copyButtonOriginalColor);

  function onCopyClicked() {
    navigator.clipboard.writeText(text);
    setCopyButtonText('Kopiert!');
    setCopyButtonLeftSection('👌');
    setCopyButtonColor('green');

    setTimeout(() => {
      setCopyButtonText(copyButtonOriginalText);
      setCopyButtonLeftSection(copyButtonOriginalEmoji);
      setCopyButtonColor(copyButtonOriginalColor);
    }, 1000);
  }

  return (
    <Button onClick={onCopyClicked} leftSection={copyButtonLeftSection} color={copyButtonColor}>
      {copyButtonText}
    </Button>
  );
}
