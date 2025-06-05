import { error } from "console";
import { PrologFile } from "./PrologVM/PrologFileSystem";
import { SwiPrologVM } from "./PrologVM/PrologVM";

declare global {
    var runQuery: (laws: string[], query: string, key: string) => Promise<string>;
}

export  async function runQuery(laws: string[], query: string, key: string): Promise<string> {
    const pvm = await SwiPrologVM.initFromArray(laws.map((x) => PrologFile.fromPrologText(x)));
    const result = pvm.executeQueryAndEvaluate(query, key);
    return JSON.stringify(result);
}

globalThis.runQuery = runQuery;