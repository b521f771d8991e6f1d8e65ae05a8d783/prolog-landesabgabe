import { PrologFile, PrologFileType } from "./PrologFileSystem";
import { PrologVM } from "./PrologVM";

import { executeQueryOnFiles, PrologFile as BackendPrologFile } from "../../../generated/npm-pkgs/prolog_landesabgabe";

export class ScryerPrologVM extends PrologVM {
	factBase: PrologFile[] = [];

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
		const ret = executeQueryOnFiles(
			this.factBase.map((x) => new BackendPrologFile(x.name, x.evaluatedProlog)),
			queryString,
		);
		return JSON.parse(ret) as any[];
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
