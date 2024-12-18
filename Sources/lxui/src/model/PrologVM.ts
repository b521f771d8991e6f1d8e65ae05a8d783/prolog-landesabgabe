import SWIPL from "swipl-wasm";
import { getRechtsbestand } from "./PrologFileSystem";

export class PrologVM {
    private swipl: Promise<SWIPL.SWIPLModule>;

    constructor(rechtsbestand: Promise<string>[] = [getRechtsbestand()]) {
        this.swipl = new Promise((resolve, reject) => {
            const prb: Promise<string[]> = Promise.all(rechtsbestand);

            prb.then((rechtsbestand: string[]) => {
                for (const lawText in rechtsbestand) {
                    const scriptElement = document.createElement("script");
                    scriptElement.type = "text/prolog";
                    scriptElement.innerHTML = lawText;

                    document.body.appendChild(scriptElement);
                }

                const swipl = SWIPL({
                    arguments: ["-q"]
                });

                swipl.then((swipl) => {
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