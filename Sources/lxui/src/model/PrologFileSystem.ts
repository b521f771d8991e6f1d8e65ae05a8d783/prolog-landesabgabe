import { defaultConfig } from "@/config/ServerConfig";
import { LandesabgabeSachverhalt } from "./PrologTemplates";

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

function generateDownloadURL(lawName: string) {
    return `${defaultConfig.getServerProtocol()}://${defaultConfig.getServerName()}:${defaultConfig.getServerPort()}/fetch-law?kurztitel=${lawName}`;
}

export const defaultLawSet: [string] = [
    "labgg"
];

export async function downloadLaw(fileName: string) {
    console.log(`Trying to download "${fileName}"`)
    const request = await fetch(generateDownloadURL(fileName));

    if(!request.ok) {
        throw request.status;
    }

    const text = await (request).text();
    return new PrologFile(fileName, text, undefined, PrologFileType.LAW);
}

export function getRechtsbestand(fileSet: string[] = defaultLawSet): Promise<PrologFile>[] {
    return fileSet.map(downloadLaw);
}
