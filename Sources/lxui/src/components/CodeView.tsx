import { useEffect, useId, useState } from 'react';
import hljs from 'highlight.js';
import { Button, Center, Code, Flex } from '@mantine/core';
import { TaskResult, usePostNormTransformationTaskStartRequest } from '@/util/RestService';
import { QueryObserverResult, UseQueryResult } from '@tanstack/react-query';

interface CodeViewProps {
  code: string;
  language: string;
  h: number;
  fileName: string;
}

export const CodeView = ({ code, language, h = 300, fileName = 'prolog.pl' }: CodeViewProps) => {
  const codeId = useId();
  const [norm, setNorm] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState<boolean>(false);
  const [normTransformationTask, setNormTransformationTask] = useState<UseQueryResult<TaskResult, Error>  | null>(null);

  useEffect(() => {
    const codeElement = document.getElementById(codeId);

    if (codeElement) {
      hljs.highlightElement(codeElement);
    }
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
    const selection = window.getSelection()!.toString();
    assert(code.includes(selection.toString()));
    setNormTransformationTask(usePostNormTransformationTaskStartRequest(selection));
  };

  const enableNormButton = (): boolean => {
    const selection = window.getSelection();
    return selection !== null && selection.rangeCount > 0 && code.includes(selection.toString());
  };

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
          <Button onClick={onDownloadClicked} leftSection={'💾'}>
            Download
          </Button>
          <Button onClick={onFullScreenClicked} leftSection={'💻'}>
            Vergrößern
          </Button>
          <Button
            disabled={!enableNormButton}
            onClick={onTransformToNormClicked}
            leftSection={'🪄'}
          >
            In Norm verwandeln
          </Button>
        </Flex>
      </Center>
    </>
  );
};
