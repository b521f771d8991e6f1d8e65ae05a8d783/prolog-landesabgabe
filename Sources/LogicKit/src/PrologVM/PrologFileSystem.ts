import { PrologSachverhalt } from "./PrologTemplates";

export enum PrologFileType {
    LAW, FACT
}

export class PrologFile {
    private _prologFileType: PrologFileType;
    private _name: string;
    private _evaluatedProlog: string | undefined;
    private _sachverhalt: PrologSachverhalt | undefined;

    constructor(name: string,
        evaluatedProlog: string | undefined,
        sachverhalt: PrologSachverhalt | undefined,
        pft: PrologFileType = PrologFileType.FACT) {
        this._name = name;
        this._evaluatedProlog = evaluatedProlog;
        this._prologFileType = pft;
        this._sachverhalt = sachverhalt
    }

    public static fromPrologText(text: string, type: PrologFileType = PrologFileType.FACT): PrologFile {
        const randomSuffix = Math.random().toString(36).substring(2, 10);
        const name = `inline_${randomSuffix}`;
        return new PrologFile(name, text, undefined, type);
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

    public get sachverhalt(): PrologSachverhalt | undefined {
        return this._sachverhalt;
    }
}
