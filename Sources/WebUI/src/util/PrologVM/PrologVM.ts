import { PrologFile, PrologFileType } from "./PrologFileSystem";
import { PrologPerson, PrologSachverhalt } from "./PrologTemplates";
import { getPrologBinding } from "./PrologUtilities";
import { SwiPrologVM } from "./SwiPrologVM";

export interface VariableBinding {
	name: string;
	values: string[];
}

export abstract class PrologVM {
	abstract execute(queryString: string, input?: Record<string, unknown>): any[];

	executeQueryAndEvaluateVariables(
		queries: [string, string][],
	): VariableBinding[] {
		return queries.map((currentQuery) => ({
			name: currentQuery[1],
			values: this.executeQueryAndEvaluate<string>(
				currentQuery[0],
				currentQuery[1],
			),
		}));
	}

	/**
	 * Executes a Prolog query and evaluates the result by extracting a specific binding.
	 *
	 * @template T - The expected type of the extracted binding.
	 * @param query - The Prolog query to be executed.
	 * @param key - The key used to extract the desired binding from the query result.
	 * @returns The extracted binding of type `T` corresponding to the specified key.
	 */
	executeQueryAndEvaluate<T>(query: string, key: string): T[] {
		const result = this.execute(query);
		return getPrologBinding<T>(result, key).filter(
			(value): value is T => value !== undefined,
		);
	}

	abstract getFactBase(): PrologFile[];
	abstract healthCheckOK(): boolean;
	abstract addFactBase(pf: PrologFile): void;
	abstract addFactBase(pf: PrologFile): void;
	abstract removeFactBase(filename: string): void;
	abstract hasFactBase(filename: string): boolean;

	/**
	 * Adds multiple Prolog fact bases to the virtual machine.
	 *
	 * This method iterates over an array of `PrologFile` objects and adds each
	 * one to the virtual machine's fact base using the `addFactBase` method.
	 *
	 * @param pfs - An array of `PrologFile` objects representing the fact bases
	 *              to be added.
	 */
	addFactBases(pfs: PrologFile[]) {
		for (const pf of pfs) {
			this.addFactBase(pf);
		}
	}

	/**
	 * Removes a fact base associated with the given filename if it exists.
	 *
	 * This method first checks if a fact base with the specified filename exists
	 * using `hasFactBase`. If it exists, it proceeds to remove it using `removeFactBase`.
	 *
	 * @param filename - The name of the file associated with the fact base to be removed.
	 */
	removeFactBaseIfExists(filename: string) {
		if (this.hasFactBase(filename)) {
			this.removeFactBase(filename);
		}
	}

	/**
	 * Removes all fact bases from the Prolog virtual machine.
	 * Iterates through the existing fact bases, ensuring each one exists
	 * before removing it. This operation clears the entire collection
	 * of fact bases managed by the virtual machine.
	 *
	 * @throws {Error} If a fact base is not found during the removal process.
	 */
	removeAllFactBases() {
		for (const i of this.getFactBase()) {
			console.assert(this.hasFactBase(i.name));
			this.removeFactBase(i.name);
		}
	}

	/**
	 *
	 * @returns an array of prolog files that includes only facts
	 */
	getFacts(): PrologFile[] {
		return this.getFactBase().filter(
			(x) => x.prologFileType === PrologFileType.FACT,
		);
	}

	/**
	 * Retrieves an array of `LandesabgabeSachverhalt` objects by mapping the facts
	 * returned from `getFacts()` to their corresponding `sachverhalt` property.
	 *
	 * @returns {LandesabgabeSachverhalt[]} An array of `LandesabgabeSachverhalt` objects.
	 */
	getSachverhalte(): PrologSachverhalt[] {
		return this.getFacts().map((f) => f.sachverhalt!);
	}

	/**
	 *
	 * @returns an array of prolog files that includes only laws
	 */
	getLaws(): PrologFile[] {
		return this.getFactBase().filter(
			(x) => x.prologFileType === PrologFileType.LAW,
		);
	}

	/**
	 * Looks up a person by their unique identifier (personID) within the facts of the PrologVM.
	 *
	 * @param personID - The unique identifier of the person to search for.
	 * @returns The `LandesabgabePerson` object if a matching person is found, or `undefined` if no match is found.
	 */
	lookupPersonByID(personID: string): PrologPerson | undefined {
		return this.getFacts().flatMap((x) =>
			x.sachverhalt!.persons.filter((p: PrologPerson) => p.personId === personID),
		)[0];
	}
}

export async function executePrologFileInPrologVM<
	T extends PrologVM = SwiPrologVM,
>(
	prologFile: PrologFile,
	queryString: string,
	VMClass: { initPrologVM: () => Promise<T> } = SwiPrologVM as any,
) {
	const pvm = await VMClass.initPrologVM();
	pvm.addFactBase(prologFile);
	return pvm.execute(queryString);
}
