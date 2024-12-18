import SWIPL from "swipl-wasm";
import { getRechtsbestand, PrologFile } from "./PrologFileSystem";

export class PrologVM {
    private swipl: Promise<SWIPL.SWIPLModule>;

    constructor(rechtsbestand: Promise<PrologFile>[] = getRechtsbestand()) {
        this.swipl = new Promise((resolve, reject) => {
            const prb: Promise<PrologFile[]> = Promise.all(rechtsbestand);

            prb.then((rechtsbestand: PrologFile[]) => {
                const swipl = SWIPL({
                    arguments: ["-q"]
                });

                swipl.then((swipl) => {
                    // TODO make this more generic
                    swipl.FS.mkdir("src");
                    swipl.FS.mkdir("src/static");

                    for (const cf of rechtsbestand) {
                        // see here: https://github.com/JanWielemaker/swi-prolog-wasm?tab=readme-ov-file#usage
                        swipl.FS.writeFile(cf.name, cf.content);
                        const query: SWIPL.Query = swipl.prolog.query("consult(file)", {
                            "file": cf.name
                        });
                        console.log(query.once());
                    }

                    resolve(swipl);
                }).catch((e) => reject(e));
            }).catch((e) => reject(e));
        });
    }

    async executeQuery(query: string, input?: Record<string, unknown>): Promise<SWIPL.Query> {
        const swipl = await this.swipl;
        return swipl.prolog.query(query, input);
    }
}