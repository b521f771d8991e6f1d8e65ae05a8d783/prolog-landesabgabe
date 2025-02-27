import { LandesabgabeSachverhalt } from "./PrologTemplates";
import SWIPL from "swipl-wasm";

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

    public async queryThisFile(queryString: string, input?: Record<string, unknown>) {
        // Step 1: Initialise a new PrologVM
        // we do not do this inside the PrologVM, because that would mess up the global environment, instead, we want to create our own temporary files
        const temporaryFileName = `/tmp/${this.name}`;

        const swipl = await SWIPL({
            arguments: ["-q"]
        });
        swipl.FS.writeFile(temporaryFileName, this.evaluatedProlog);

        const queryLoad: SWIPL.Query = swipl.prolog.query("load_files(File)", {
            "File": temporaryFileName
        });
        console.log(queryLoad.once());

        // Step 2: Execute the Query

        let ret: any[] = [];
        let query = swipl.prolog.query(queryString, input);
        let current: any;

        do {
            current = query.next()
            ret.push(current.value);
        } while('done' in current && !current.done);

        // Step 3: Clean up & Return

        const queryUnload: SWIPL.Query = swipl.prolog.query("unload_file(File)", {
            "File": temporaryFileName
        });
        console.log(queryUnload.once())

        swipl.FS.unlink(temporaryFileName);

        return ret;
    }
}
