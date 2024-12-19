import SWIPL, { Prolog } from "swipl-wasm";
import { getRechtsbestand, PrologFile } from "./PrologFileSystem";
import { v4 as uuid } from 'uuid';

export class PrologVM {
    private swipl: SWIPL.SWIPLModule;
    private factBase: PrologFile[];

    constructor(swipl: SWIPL.SWIPLModule) {
        this.swipl = swipl;
        this.factBase = [];
    }

    // language designers should consider using paradigms such as ObjC init more, they would make stuff like this MUCH easier
    // https://developer.apple.com/documentation/objectivec/nsobject/1418639-initialize?language=objc
    public static async init(rechtsbestand: (Promise<PrologFile> | PrologFile)[] = getRechtsbestand()): Promise<PrologVM> {
        const rechtsbestandPromises: Promise<PrologFile>[] = rechtsbestand.filter((x) => x instanceof Promise);
        const rechtsbestandFiles: PrologFile[] = rechtsbestand.filter((x) => x instanceof PrologFile);
        const rechtsbestandPromisesResolved = await Promise.all(rechtsbestandPromises);

        const pfs: PrologFile[] = [
            ...rechtsbestandPromisesResolved,
            ...rechtsbestandFiles
        ];

        const swipl = new PrologVM(await PrologVM.initializePrologModule());

        // TODO make this more generic
        swipl.swipl.FS.mkdir("src");
        swipl.swipl.FS.mkdir("src/static");
        await swipl.addFactBases(pfs);
        return swipl;
    }

    private savedFiles(): string[] {
        const dir = this.swipl.FS.readdir("/");
        return dir;
    }

    private static async initializePrologModule(): Promise<SWIPL.SWIPLModule> {
        return await SWIPL({
            arguments: ["-q"]
        });
    }

    addFactBase(pf: PrologFile) {
        // see here: https://github.com/JanWielemaker/swi-prolog-wasm?tab=readme-ov-file#usage
        this.swipl.FS.writeFile(pf.name, pf.content);

        // https://www.swi-prolog.org/pldoc/doc_for?object=load_files/1
        const query: SWIPL.Query = this.swipl.prolog.query("load_files(File)", {
            // variable bindings go here
            "File": pf.name
        });

        //console.assert(query.once().success === true);
        console.log(`Loaded prolog file: ${pf.name}`);

        this.factBase.push(pf);
    }

    addFactBases(pfs: PrologFile[]) {
        for (const pf of pfs) {
            this.addFactBase(pf);
        }
    }

    removeFactBase(filename: string) {
        const query: SWIPL.Query = this.swipl.prolog.query("unload_file(File)", {
            "File": filename
        });

        //console.assert('success' in query.once());
        this.swipl.FS.unlink(filename);
    }

    removeFactBaseIfExists(filename: string) {
        if (this.hasFactBase(filename)) {
            this.hasFactBase(filename);
        }
    }

    hasFactBase(filename: string): boolean {
        return this.factBase.some((x: PrologFile) => x.name === filename);
    }

    // untested
    async reboot(): Promise<void> {
        const temporaryPrologVM = await PrologVM.init(this.factBase);
        this.swipl = temporaryPrologVM.swipl;
    }

    executeQuery(query: string, input?: Record<string, unknown>): SWIPL.Query {
        return this.swipl.prolog.query(query, input);
    }

    evaluate() {
        return "";
    }

    public static getUniqueFilename() {
        return `input_${uuid().replaceAll('-', '_')}.pl`;
    }
}