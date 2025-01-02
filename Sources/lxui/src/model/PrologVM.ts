import SWIPL, { Prolog } from "swipl-wasm";
import { getRechtsbestand, PrologFile } from "./PrologFileSystem";
import { v4 as uuid } from 'uuid';

export type FactBaseListener = (factBase: PrologFile[]) => void;

const LOCAL_STORAGE_KEY: string = "factBase";

// this is also used for state management in the UI
export class PrologVM {
    private swipl: SWIPL.SWIPLModule;
    private factBase: PrologFile[];
    private addFactBaseEvents: FactBaseListener[] = [];

    constructor(swipl: SWIPL.SWIPLModule) {
        this.swipl = swipl;
        this.factBase = [];
    }

    private static async initPrologVM(): Promise<PrologVM> {
        const swipl = new PrologVM(await PrologVM.initializePrologModule());

        // TODO make this more generic
        swipl.swipl.FS.mkdir("src");
        swipl.swipl.FS.mkdir("src/static");
        return swipl;
    }

    private static async awaitPrologFiles(rechtsbestand: (PrologFile | Promise<PrologFile>)[]): Promise<PrologFile[]> {
        const rechtsbestandPromises: Promise<PrologFile>[] = rechtsbestand.filter((x) => x instanceof Promise);
        const rechtsbestandFiles: PrologFile[] = rechtsbestand.filter((x) => x instanceof PrologFile);
        const rechtsbestandPromisesResolved = await Promise.all(rechtsbestandPromises);

        const pfs: PrologFile[] = [
            ...rechtsbestandPromisesResolved,
            ...rechtsbestandFiles
        ];
        return pfs;
    }

    // language designers should consider using paradigms such as ObjC init more, they would make stuff like this MUCH easier
    // https://developer.apple.com/documentation/objectivec/nsobject/1418639-initialize?language=objc
    public static async initFromArray(rechtsbestand: (Promise<PrologFile> | PrologFile)[] = getRechtsbestand()): Promise<PrologVM> {
        const pfs: PrologFile[] = await PrologVM.awaitPrologFiles(rechtsbestand);

        const swipl = await PrologVM.initPrologVM();
        await swipl.addFactBases(pfs);
        return swipl;
    }

    // creates a new PrologVM instance from the local storage
    // automatically adds a fact base listener to save the fact base to local storage when it changes
    public static async initFromLocalStorage(rechtsbestand: (Promise<PrologFile> | PrologFile)[] = getRechtsbestand()): Promise<PrologVM> {
        if (!this.hasLocalStorageFactBase()) {
            return await this.initFromArray(rechtsbestand);
        }

        const factBaseString = localStorage.getItem(LOCAL_STORAGE_KEY)!;
        const factBase = JSON.parse(factBaseString) as PrologFile[];
        const swipl = await PrologVM.initPrologVM();

        await swipl.addFactBases(factBase);
        swipl.addFactBaseListener(swipl.saveToLocalStorage.bind(swipl));
        return swipl;
    }

    public static hasLocalStorageFactBase(): boolean {
        return localStorage.getItem(LOCAL_STORAGE_KEY) !== null;
    }

    public saveToLocalStorage() {
        localStorage.removeItem(LOCAL_STORAGE_KEY);
        localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify(this.factBase));
    }

    private static async initializePrologModule(): Promise<SWIPL.SWIPLModule> {
        return await SWIPL({
            arguments: ["-q"]
        });
    }

    addFactBaseListener(listener: FactBaseListener) {
        this.addFactBaseEvents.push(listener);
    }

    /**
     * This functions is used to add a fact base to the prolog VM.
     * Listeners are notified when a fact base is added.
     * @param pf the Prolog fact base to add
     */
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

        for (const listener of this.addFactBaseEvents) {
            listener(this.factBase);
        }

        this.saveToLocalStorage();
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
        console.log(`Removed fact base ${filename}`)
    }

    removeFactBaseIfExists(filename: string) {
        if (this.hasFactBase(filename)) {
            this.removeFactBase(filename);
        }
    }

    hasFactBase(filename: string): boolean {
        return this.factBase.some((x: PrologFile) => x.name === filename);
    }

    // untested
    async reboot(): Promise<void> {
        const temporaryPrologVM = await PrologVM.initFromArray(this.factBase);
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

    getFactBase(): PrologFile[] {
        return this.factBase;
    }
}