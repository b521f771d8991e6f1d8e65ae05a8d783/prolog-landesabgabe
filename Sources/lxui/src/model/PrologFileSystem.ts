import { LandesabgabeSachverhalt } from "./PrologTemplates";

export const labbgPl = new URL("../static/labgg.pl", import.meta.url);

export enum PrologFileType {
    LAW, FACT
}

export class PrologFile {
    private _prologFileType: PrologFileType;
    private _name: string;
    private _evaluatedProlog: string | undefined;
    private _sachverhalt: LandesabgabeSachverhalt | undefined;

    constructor(name: string,
        evaluatedProlog: string | undefined,
        sachverhalt: LandesabgabeSachverhalt | undefined,
        pft: PrologFileType = PrologFileType.FACT) {
        this._name = name;
        this._evaluatedProlog = evaluatedProlog;
        this._prologFileType = pft;
        this._sachverhalt = sachverhalt
    }

    public get prologFileType() {
        return this._prologFileType;
    }

    public get name() {
        return this._name;
    }

    public get evaluatedProlog(): string {
        if (this._evaluatedProlog) {
            return this._evaluatedProlog;
        }

        if (this._sachverhalt) {
            return this._sachverhalt.serialize2Prolog();
        }

        return "";
    }

    public get sachverhalt(): LandesabgabeSachverhalt | undefined {
        return this._sachverhalt;
    }
}

export const defaultFileSet: [URL] = [labbgPl];

export function getRechtsbestand(fileSet: URL[] = defaultFileSet): Promise<PrologFile>[] {
    return fileSet.map(async (url: URL): Promise<PrologFile> => {
        const text = await (await fetch(url)).text();
        return new PrologFile(url.pathname, text, undefined, PrologFileType.LAW)
    });
}
