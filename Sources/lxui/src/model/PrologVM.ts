import SWIPL from "swipl-wasm";
import { getRechtsbestand, PrologFile } from "./PrologFileSystem";
import { v4 as uuid } from 'uuid';

export type FactBaseListener = (factBase: PrologFile[]) => void;

export class PrologVM {
    private swipl: SWIPL.SWIPLModule;
    private factBase: PrologFile[];
    private addFactBaseEvents: FactBaseListener[];

    private constructor(swipl: SWIPL.SWIPLModule, factBase: PrologFile[] = []) {
        this.swipl = swipl;
        this.factBase = factBase;
        this.addFactBaseEvents = [];
    }

    private static async initPrologVM(): Promise<PrologVM> {
        const swipl = new PrologVM(await PrologVM.initializePrologModule());
        return swipl;
    }

    private static async awaitPrologFiles(rechtsbestand: (PrologFile | Promise<PrologFile>)[]): Promise<PrologFile[]> {
        const rechtsbestandPromises: Promise<PrologFile>[] = rechtsbestand.filter((x) => x instanceof Promise);
        const rechtsbestandFiles: PrologFile[] = rechtsbestand.filter((x) => x instanceof PrologFile);
        const rechtsbestandPromisesResolved = await Promise.all(rechtsbestandPromises);

        return [...rechtsbestandPromisesResolved, ...rechtsbestandFiles];
    }

    // language designers should consider using paradigms such as ObjC init more, they would make stuff like this MUCH easier
    // https://developer.apple.com/documentation/objectivec/nsobject/1418639-initialize?language=objc
    public static async initFromArray(rechtsbestand: (Promise<PrologFile> | PrologFile)[] = getRechtsbestand()): Promise<PrologVM> {
        const pfs: PrologFile[] = await PrologVM.awaitPrologFiles(rechtsbestand);

        const swipl = await PrologVM.initPrologVM();
        await swipl.addFactBases(pfs);
        return swipl;
    }

    public static async initFromLocalStorage(rechtsbestand: (Promise<PrologFile> | PrologFile)[] = getRechtsbestand()): Promise<PrologVM> {
        // TODO
        return await this.initFromArray(rechtsbestand);
    }

    private static async initializePrologModule(): Promise<SWIPL.SWIPLModule> {
        return await SWIPL({
            arguments: ["-q"]
        });
    }

    addFactBaseListener(listener: FactBaseListener) {
        this.addFactBaseEvents.push(listener);
    }

    protected spawnTopLevelDirectoriesFromURL(url: string) {
        console.log("Creating folder: ", url)
        const urlCapped: string = url.startsWith("/") ? url.substring(1) : url;
        const segments: string[] = urlCapped.split("/");
        const segmentsWithoutLast: string[] = segments.slice(0, segments.length - 1); // the last one is the file itself
        let current: string = "";

        for(const i of segmentsWithoutLast) {
            current = `${current}/${i}`;
            this.swipl.FS.mkdir(current);
        }
    }

    /**
     * This functions is used to add a fact base to the prolog VM.
     * Listeners are notified when a fact base is added.
     * An older fact base with the same name is removed if it exists.
     * @param pf the Prolog fact base to add
     */
    addFactBase(pf: PrologFile) {
        this.removeFactBaseIfExists(pf.name);
        this.spawnTopLevelDirectoriesFromURL(pf.name);

        // see here: https://github.com/JanWielemaker/swi-prolog-wasm?tab=readme-ov-file#usage
        this.swipl.FS.writeFile(pf.name, pf.evaluatedProlog);

        // https://www.swi-prolog.org/pldoc/doc_for?object=load_files/1
        const query: SWIPL.Query = this.swipl.prolog.query("load_files(File)", {
            // variable bindings go here
            "File": pf.name
        });
        const result = query.once();
        console.log(`Loaded fact base`, result)

        this.factBase.push(pf);

        for (const listener of this.addFactBaseEvents) {
            listener(this.factBase);
        }
    }

    addFactBases(pfs: PrologFile[]) {
        for (const pf of pfs) {
            this.addFactBase(pf);
        }
    }

    /*
    * cleans up the fact base, both from the state and from the prolog file system
    */
    removeFactBase(filename: string) {
        const query: SWIPL.Query = this.swipl.prolog.query("unload_file(File)", {
            "File": filename
        });

        //console.assert('success' in query.once());
        this.swipl.FS.unlink(filename);
        this.factBase = this.factBase.filter((pf: PrologFile) => pf.name !== filename);
        console.log(`Removed fact base ${filename}`);
    }

    removeFactBaseIfExists(filename: string) {
        if (this.hasFactBase(filename)) {
            this.removeFactBase(filename);
        }
    }

    hasFactBase(filename: string): boolean {
        return this.factBase.some((x: PrologFile) => x.name === filename);
    }

    executeQuery(query: string, input?: Record<string, unknown>): SWIPL.Query {
        return this.swipl.prolog.query(query, input);
    }

    public static getUniqueFilename() {
        return `input_${uuid().replaceAll('-', '_')}.pl`;
    }

    getFactBase(): PrologFile[] {
        return this.factBase;
    }
}