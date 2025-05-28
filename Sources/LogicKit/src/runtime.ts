import { error } from "console";
import { PrologFile } from "./PrologVM/PrologFileSystem";
import { SwiPrologVM } from "./PrologVM/PrologVM";

declare global {
    var runQuery: (laws: PrologFile[], query: string, key: string) => Promise<string>;
}

export  async function runQuery(laws: PrologFile[], query: string, key: string): Promise<string> {
    const pvm = await SwiPrologVM.initFromArray(laws);
    const result = pvm.executeQueryAndEvaluate(query, key);
    console.log("Got result", JSON.stringify(result));
    return JSON.stringify(result);
}

globalThis.runQuery = runQuery;