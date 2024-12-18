import SWIPL from "swipl-wasm";
import { getRechtsbestand, PrologFile } from "./PrologFileSystem";

export class PrologVM {
    private swipl: Promise<SWIPL.SWIPLModule>;

    constructor() {
        this.swipl = new Promise((resolve, reject) => {
            const swipl: Promise<SWIPL.SWIPLModule> = SWIPL({
                arguments: ["-q"]
            });

            swipl.then((swipl) => resolve(swipl))
                .catch((e) => reject(e));
        });

        this.swipl.then()
    }

    // language designers should consider using paradigms such as ObjC init more, they would make stuff like this MUCH easier
    // https://developer.apple.com/documentation/objectivec/nsobject/1418639-initialize?language=objc
    public static async init(rechtsbestand: Promise<PrologFile>[] = getRechtsbestand()): Promise<PrologVM> {
        const pfs: PrologFile[] = await Promise.all(rechtsbestand);
        const swipl = new PrologVM();
        await swipl.addFacts(pfs);
        return swipl;
    }

    async addFact(pf: PrologFile): Promise<void> {
        // see here: https://github.com/JanWielemaker/swi-prolog-wasm?tab=readme-ov-file#usage
        const swipl = await this.swipl;

        // TODO make this more generic
        swipl.FS.mkdir("src");
        swipl.FS.mkdir("src/static");
        swipl.FS.writeFile(pf.name, pf.content);

        const query: SWIPL.Query = swipl.prolog.query("consult(File)", {
            // variable bindings go here
            "File": pf.name
        });

        console.assert(query.once().success === true);
        console.log(`Loaded prolog file: ${pf.name}`);
    }

    async addFacts(pfs: PrologFile[]): Promise<void> {
        for (const pf of pfs) {
            await this.addFact(pf);
        }
    }

    async executeQuery(query: string, input?: Record<string, unknown>): Promise<SWIPL.Query> {
        const swipl = await this.swipl;
        return swipl.prolog.query(query, input);
    }

    async evaluate() {
        return "";
    }
}