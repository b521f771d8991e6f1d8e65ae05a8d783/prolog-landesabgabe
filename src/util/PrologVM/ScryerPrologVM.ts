import { PrologFile, PrologFileType } from "./PrologFileSystem";
import { PrologVM } from "./PrologVM";

import { Prolog } from "scryer";

export class ScryerPrologVM extends PrologVM {
	factBase: PrologFile[] = [];
	private prolog: Prolog;

	constructor() {
		super();
		this.prolog = new Prolog({ concurrency: "interrupt" });
	}

	static async initPrologVM(): Promise<ScryerPrologVM> {
		return new ScryerPrologVM();
	}

	static async initFromArray(rechtsbestand: PrologFile[]): Promise<ScryerPrologVM> {
		const vm = new ScryerPrologVM();
		vm.addFactBases(rechtsbestand.filter((x) => x instanceof PrologFile));
		return vm;
	}

	static async initFromAppState(rechtsbestand: string): Promise<ScryerPrologVM> {
		const pf = new PrologFile("labgg", rechtsbestand, undefined, PrologFileType.LAW);
		return await this.initFromArray([pf]);
	}

	execute(queryString: string, input?: Record<string, unknown>): any[] {
		for (const pf of this.factBase) {
			this.prolog.consultText(pf.evaluatedProlog);
		}

		const results: any[] = [];
		const query = this.prolog.query(queryString);
		for (const answer of query) {
			results.push(answer.bindings);
		}
		return results;
	}

	getFactBase(): PrologFile[] {
		return this.factBase;
	}

	healthCheckOK(): boolean {
		return true;
	}

	addFactBase(pf: PrologFile): void {
		this.factBase.push(pf);
	}

	removeFactBase(filename: string): void {
		this.factBase = this.factBase.filter((pf: PrologFile) => pf.name !== filename);
	}

	hasFactBase(filename: string): boolean {
		return this.factBase.some((x: PrologFile) => x.name === filename);
	}
}
