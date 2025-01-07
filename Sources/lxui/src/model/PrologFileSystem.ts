import { LandesabgabeHandlung, LandesabgabePerson } from "./PrologTemplates";

export const labbgPl = new URL("../static/labgg.pl", import.meta.url);

export type AddFactFileFunction = (prologFile: PrologFile) => void;

export enum PrologFileType {
    LAW, FACT
}

export class PrologFile {
    public prologFileType: PrologFileType;
    public name: string;
    public content: string;
    public handlungen: LandesabgabeHandlung[];
    public savedPersons: LandesabgabePerson[];

    constructor(name: string,
        content: string,
        handlung: LandesabgabeHandlung[] = [],
        person: LandesabgabePerson[] = [],
        pft: PrologFileType = PrologFileType.FACT) {
        this.name = name;
        this.content = content;
        this.handlungen = handlung;
        this.prologFileType = pft;
        this.savedPersons = person;
    }
}

export const defaultFileSet: [URL] = [labbgPl];

export function getRechtsbestand(fileSet: URL[] = defaultFileSet): Promise<PrologFile>[] {
    return fileSet.map(async (url: URL): Promise<PrologFile> => {
        const response = await fetch(url);
        return {
            name: url.pathname,
            content: await response.text(),
            handlungen: [],
            savedPersons: [],
            prologFileType: PrologFileType.LAW
        }
    });
}
