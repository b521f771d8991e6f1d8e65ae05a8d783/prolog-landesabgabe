import { Code } from "@mantine/core";
import hljs from "highlight.js";
import { useEffect, useId } from "react";

export function CodeView({ code, language, h = 300 }: {
    code: string,
    language: string,
    h: number
}) {
    const codeId = useId();

    useEffect(() => {
        const codeElement = document.getElementById(codeId);

        if (codeElement) {
            hljs.highlightElement(codeElement);
        }
    }, [code]);

    return <Code h={h} block>
        <code id={codeId} className={language}>
            {code}
        </code>
    </Code>;
}