import { PrologFile, PrologFileType } from "./PrologFileSystem";
import { PrologVM } from "./PrologVM";
import SWIPL from "swipl-wasm";
import { v4 as uuid } from "uuid";

export class SwiPrologVM extends PrologVM {
	private swipl: SWIPL.SWIPLModule;
	private factBase: PrologFile[];

	private constructor(swipl: SWIPL.SWIPLModule, factBase: PrologFile[] = []) {
		super();
		this.swipl = swipl;
		this.factBase = factBase;
	}

	public static async initPrologVM(): Promise<SwiPrologVM> {
		return new SwiPrologVM(await SwiPrologVM.initializePrologModule());
	}

	static async initFromArray(rechtsbestand: PrologFile[]): Promise<SwiPrologVM> {
		const pfs: PrologFile[] = rechtsbestand.filter(
			(x) => x instanceof PrologFile,
		);
		const swipl = await SwiPrologVM.initPrologVM();
		swipl.addFactBases(pfs);
		return swipl;
	}

	static async initFromAppState(rechtsbestand: string): Promise<SwiPrologVM> {
		const pf = new PrologFile(
			"labgg",
			rechtsbestand,
			undefined,
			PrologFileType.LAW,
		);
		return await this.initFromArray([pf]);
	}

	private static async initializePrologModule(): Promise<SWIPL.SWIPLModule> {
		return await SWIPL({
			arguments: ["-q"],
		});
	}

	protected spawnTopLevelDirectoriesFromURL(url: string) {
		const urlCapped: string = url.startsWith("/") ? url.substring(1) : url;
		const segments: string[] = urlCapped.split("/");
		const segmentsWithoutLast: string[] = segments.slice(0, segments.length - 1); // the last one is the file itself
		let current: string = "";

		for (const i of segmentsWithoutLast) {
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
			File: pf.name,
		});
		const result = query.once();
		console.log(`Loaded fact base`, result);

		this.factBase.push(pf);
	}

	/*
	 * cleans up the fact base, both from the state and from the prolog file system
	 */
	removeFactBase(filename: string) {
		const query: SWIPL.Query = this.swipl.prolog.query("unload_file(File)", {
			File: filename,
		});

		console.log("Unloaded fact base", query.once());
		this.swipl.FS.unlink(filename);
		this.factBase = this.factBase.filter(
			(pf: PrologFile) => pf.name !== filename,
		);
	}

	/**
	 * Checks if a fact base with the specified filename exists in the current collection.
	 *
	 * @param filename - The name of the file to check for in the fact base.
	 * @returns `true` if a fact base with the given filename exists, otherwise `false`.
	 */
	hasFactBase(filename: string): boolean {
		return this.factBase.some((x: PrologFile) => x.name === filename);
	}

	private healthCheck(): [string, boolean][] {
		return this.factBase.map((x: PrologFile) => [
			x.name,
			this.hasFactBase(x.name),
		]);
	}

	/**
	 * Checks the health status of the system by verifying all fact bases.
	 *
	 * This method iterates through the results of the `healthCheck` method,
	 * which returns an array of tuples containing the name of a fact base
	 * and its corresponding health status (boolean). If any fact base is
	 * found to be faulty (i.e., its health status is `false`), an error
	 * message is logged to the console indicating the faulty fact base.
	 *
	 * @returns {boolean} `true` if all fact bases are healthy, otherwise `false`.
	 */
	healthCheckOK(): boolean {
		return this.healthCheck().every((x: [string, boolean]) => {
			if (x[1] === false) {
				console.error(`Fact base ${x[0]} is faulty`);
			}

			return x[1];
		});
	}

	private executeQuery(
		query: string,
		input?: Record<string, unknown>,
		healthCheck: boolean = true,
	): SWIPL.Query {
		if (healthCheck) {
			this.healthCheckOK();
		}

		return this.swipl.prolog.query(query, input);
	}

	/**
	 * Executes a Prolog query and returns the results as an array.
	 *
	 * @param queryString - The Prolog query to execute as a string.
	 * @param input - An optional record of input variables to bind to the query.
	 * @param healthCheck - A boolean flag to enable or disable health checks before execution. Defaults to `true`.
	 * @returns An array of results obtained from executing the query.
	 */
	execute(
		queryString: string,
		input?: Record<string, unknown>,
		healthCheck: boolean = true,
	): any[] {
		let ret: any[] = [];
		let query = this.executeQuery(queryString, input, healthCheck);
		let current: any = query.next();

		while ("value" in current) {
			ret.push(current.value);
			current = query.next();
		}
		console.assert("done" in current && current.done);

		return ret;
	}

	static getUniqueFilename() {
		return `input_${uuid().replaceAll("-", "_")}.pl`;
	}

	/**
	 *
	 * @returns an array of prolog files that include both facts and laws
	 */
	getFactBase(): PrologFile[] {
		return this.factBase;
	}
}