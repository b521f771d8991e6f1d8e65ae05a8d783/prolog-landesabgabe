import { PrologFile } from "./PrologFileSystem";
import { PrologVM } from "./PrologVM";

import { executeQueryOnFiles, PrologFile as BackendPrologFile } from "../../../../../generated/npm-pkgs/prolog_landesabgabe";

export class ScryerPrologVM extends PrologVM {
    factBase: PrologFile[] = [];

    execute(queryString: string, input?: Record<string, unknown>): any[] {
        const ret = executeQueryOnFiles(this.factBase.map((x) => new BackendPrologFile(x.name, x.evaluatedProlog)), queryString);
        return JSON.parse(ret) as any[];
    }

    getFactBase(): PrologFile[] {
        return this.factBase;
    }

    healthCheckOK(): boolean {
        return true;
    }

    addFactBase(pf: PrologFile): void {
        this.factBase.push(pf);
    }

    removeFactBase(filename: string): void {
        this.factBase = this.factBase.filter(
            (pf: PrologFile) => pf.name !== filename,
        );
    }

    hasFactBase(filename: string): boolean {
        return this.factBase.some((x: PrologFile) => x.name === filename);
    }
}