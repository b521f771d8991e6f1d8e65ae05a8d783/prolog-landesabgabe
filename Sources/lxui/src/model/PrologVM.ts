import SWIPL from "swipl-wasm";
import { getRechtsbestand, PrologFile, PrologFileType } from "./PrologFileSystem";
import { v4 as uuid } from 'uuid';
import { LandesabgabePerson, LandesabgabeSachverhalt } from "./PrologTemplates";

// AppState is dead, long live the AppState
export class PrologVM {
    private swipl: SWIPL.SWIPLModule;
    private factBase: PrologFile[];

    private constructor(swipl: SWIPL.SWIPLModule, factBase: PrologFile[] = []) {
        this.swipl = swipl;
        this.factBase = factBase;
    }

    private static async initPrologVM(): Promise<PrologVM> {
        return new PrologVM(await PrologVM.initializePrologModule());
    }

    private static async awaitPrologFiles(rechtsbestand: (PrologFile | Promise<PrologFile>)[]): Promise<PrologFile[]> {
        const rechtsbestandPromises: Promise<PrologFile>[] = rechtsbestand.filter((x) => x instanceof Promise);
        const rechtsbestandFiles: PrologFile[] = rechtsbestand.filter((x) => x instanceof PrologFile);
        const rechtsbestandPromisesResolved = await Promise.all(rechtsbestandPromises);

        return [...rechtsbestandPromisesResolved, ...rechtsbestandFiles];
    }

    // language designers should consider using paradigms such as ObjC init more, they would make stuff like this MUCH easier
    // https://developer.apple.com/documentation/objectivec/nsobject/1418639-initialize?language=objc
    static async initFromArray(rechtsbestand: (Promise<PrologFile> | PrologFile)[] = getRechtsbestand()): Promise<PrologVM> {
        const pfs: PrologFile[] = await PrologVM.awaitPrologFiles(rechtsbestand);
        const swipl = await PrologVM.initPrologVM();
        await swipl.addFactBases(pfs);
        return swipl;
    }

    static async initFromAppState(rechtsbestand: (Promise<PrologFile> | PrologFile)[] = getRechtsbestand()): Promise<PrologVM> {
        // TODO
        // init the PrologVM from Redux
        return await this.initFromArray(rechtsbestand);
    }

    private static async initializePrologModule(): Promise<SWIPL.SWIPLModule> {
        return await SWIPL({
            arguments: ["-q"]
        });
    }

    protected spawnTopLevelDirectoriesFromURL(url: string) {
        const urlCapped: string = url.startsWith("/") ? url.substring(1) : url;
        const segments: string[] = urlCapped.split("/");
        const segmentsWithoutLast: string[] = segments.slice(0, segments.length - 1); // the last one is the file itself
        let current: string = "";

        for(const i of segmentsWithoutLast) {
            current = `${current}/${i}`;
            console.log("Creating folder: ", i);
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
        console.log(`Loaded fact base`, result);

        this.factBase.push(pf);
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

        console.log("Unloaded fact base", query.once());
        this.swipl.FS.unlink(filename);
        this.factBase = this.factBase.filter((pf: PrologFile) => pf.name !== filename);
    }

    removeFactBaseIfExists(filename: string) {
        if (this.hasFactBase(filename)) {
            this.removeFactBase(filename);
        }
    }

    hasFactBase(filename: string): boolean {
        return this.factBase.some((x: PrologFile) => x.name === filename);
    }

    removeAllFactBases() {
        for(const i of this.factBase) {
            assert(this.hasFactBase(i.name));
            this.removeFactBase(i.name);
        }
    }

    healthCheck(): [string, boolean][] {
        return this.factBase.map((x: PrologFile) => [x.name, this.hasFactBase(x.name)]);
    }

    healthCheckOK(): boolean {
        return this.healthCheck().every((x: [string, boolean]) => {
            if(x[1] === false) {
                console.error(`Fact base ${x[0]} is faulty`);
            }

            return x[1];
        });
    }

    executeQuery(query: string, input?: Record<string, unknown>, healthCheck: boolean = true): SWIPL.Query {
        if(healthCheck) {
            this.healthCheckOK();
        }

        return this.swipl.prolog.query(query, input);
    }

    execute(queryString: string, input?: Record<string, unknown>, healthCheck: boolean = true): any[] {
        let ret: any[] = [];
        let query = this.executeQuery(queryString, input, healthCheck);
        let current: any;

        do {
            current = query.next()
            ret.push(current.value);
        } while('done' in current && !current.done);

        return ret;
    }

    static getUniqueFilename() {
        return `input_${uuid().replaceAll('-', '_')}.pl`;
    }

    // TODO move this out of this file, does not fit well here

    /**
     * 
     * @returns an array of prolog files that include both facts and laws
     */
    getFactBase(): PrologFile[] {
        return this.factBase;
    }

    /**
     * 
     * @returns an array of prolog files that includes only facts
     */
    getFacts(): PrologFile[] {
        return this.getFactBase().filter((x) => x.prologFileType === PrologFileType.FACT);
    }

    getSachverhalte(): LandesabgabeSachverhalt[] {
        return this.getFacts().map((f) => f.sachverhalt!);
    }

    /**
     * 
     * @returns an array of prolog files that includes only laws
     */
    getLaws(): PrologFile[] {
        return this.getFactBase().filter((x) => x.prologFileType === PrologFileType.LAW);
    }

    lookupPersonByID(personID: string): LandesabgabePerson | undefined {
        return this.getFacts().flatMap((x) => 
            x.sachverhalt!.persons.filter((p) => p.personId === personID))[0];
    }
}