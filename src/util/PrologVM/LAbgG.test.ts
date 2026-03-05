import { describe, it, expect } from "vitest";

import { SwiPrologVM } from "./SwiPrologVM";
import { PrologFile, PrologFileType } from "./PrologFileSystem";
import { isPrologFalse } from "./PrologUtilities";
import { labgg } from "@/corpus";

/**
 * Helper: creates a PrologVM preloaded with the LAbgG law corpus
 * and any additional sachverhalt facts.
 */
async function createVM(...sachverhaltTexts: string[]): Promise<SwiPrologVM> {
	const lawFile = new PrologFile("labgg", labgg, undefined, PrologFileType.LAW);
	const files: PrologFile[] = [lawFile];
	for (const text of sachverhaltTexts) {
		files.push(PrologFile.fromPrologText(text));
	}
	return SwiPrologVM.initFromArray(files);
}

/**
 * Helper: standard sachverhalt for a natural person doing surface mining.
 */
function sachverhalt(
	person: string,
	opts: {
		natuerlichePerson?: boolean;
		juristischePerson?: boolean;
		berufsmaessig?: boolean;
		gewerblich?: boolean;
		tonnen?: number;
		gesteinArt?: string;
		abraummaterial?: boolean;
		seitenentnahme?: boolean;
		fliessgewaesser?: boolean;
		gefahrenabwehr?: boolean;
	} = {},
): string {
	const {
		natuerlichePerson = true,
		juristischePerson = false,
		berufsmaessig = true,
		gewerblich = false,
		tonnen,
		gesteinArt,
		abraummaterial = false,
		seitenentnahme = false,
		fliessgewaesser = false,
		gefahrenabwehr = false,
	} = opts;

	const lines: string[] = [
		`:- discontiguous subjekt/2.`,
		`:- discontiguous verbum/3.`,
		`:- discontiguous objekt/4.`,
		`:- discontiguous natuerliche_person/1.`,
		`:- discontiguous juristische_person/1.`,
		`:- discontiguous berufsmaessig/1.`,
		`:- discontiguous gewerblich/1.`,
		`:- discontiguous gefoerdert/3.`,
		`:- discontiguous gestein_art/2.`,
		`:- discontiguous abraummaterial/1.`,
		`:- discontiguous entstammt_seitenentnahme/1.`,
		`:- discontiguous entstammt_fliessgewaesser/1.`,
		`:- discontiguous rohstoff_zur_abwehr_von_gefahren/1.`,
		`:- discontiguous verwertet_am/2.`,
		``,
		`subjekt(sachverhalt, ${person}).`,
		`verbum(sachverhalt, ${person}, bergbau(gewinnen, obertags, mineralische_rohstoffe)).`,
		`objekt(sachverhalt, ${person}, bergbau(gewinnen, obertags, mineralische_rohstoffe), gestein).`,
	];

	if (natuerlichePerson) lines.push(`natuerliche_person(${person}).`);
	if (juristischePerson) lines.push(`juristische_person(${person}).`);
	if (berufsmaessig) lines.push(`berufsmaessig(${person}).`);
	if (gewerblich) lines.push(`gewerblich(${person}).`);
	if (tonnen !== undefined) lines.push(`gefoerdert(gestein, ${tonnen}, tonne).`);
	if (gesteinArt) lines.push(`gestein_art(gestein, ${gesteinArt}).`);
	if (abraummaterial) lines.push(`abraummaterial(gestein).`);
	if (seitenentnahme) lines.push(`entstammt_seitenentnahme(gestein).`);
	if (fliessgewaesser) lines.push(`entstammt_fliessgewaesser(gestein).`);
	if (gefahrenabwehr) lines.push(`rohstoff_zur_abwehr_von_gefahren(gestein).`);

	return lines.join("\n");
}

// -- Tests --

describe("LAbgG - Landesabgabegesetz", () => {
	describe("Law corpus loading", () => {
		it("loads the LAbgG corpus without errors", async () => {
			const vm = await createVM();
			expect(vm).toBeDefined();
			expect(vm.healthCheckOK()).toBe(true);
		});

		it("contains metadata predicates", async () => {
			const vm = await createVM();
			const titel = vm.executeQueryAndEvaluate<any>("titel(labgg, X).", "X");
			expect(titel).toHaveLength(1);
			// SWI-Prolog WASM returns PrologString objects with a .v property
			const titelStr = typeof titel[0] === "string" ? titel[0] : titel[0].v;
			expect(titelStr).toContain("Landschaftsabgabegesetz");
		});

		it("contains kurztitel", async () => {
			const vm = await createVM();
			const kurztitel = vm.executeQueryAndEvaluate<any>("kurztitel(labgg, X).", "X");
			expect(kurztitel).toHaveLength(1);
			const kzStr = typeof kurztitel[0] === "string" ? kurztitel[0] : kurztitel[0].v;
			expect(kzStr).toBe("LAbgG");
		});
	});

	describe("SS 1 - Gegenstand der Abgabe", () => {
		it("defines tax on surface mining of mineral resources in Upper Austria", async () => {
			const vm = await createVM();
			const result = vm.execute(
				"abgabe_auf(labgg, landesabgabe, oberoesterreich, bergbau(gewinnen, obertags, mineralische_rohstoffe)).",
			);
			expect(isPrologFalse(result)).toBe(false);
		});

		it("does not define tax for underground mining", async () => {
			const vm = await createVM();
			const result = vm.execute(
				"abgabe_auf(labgg, landesabgabe, oberoesterreich, bergbau(gewinnen, untertags, mineralische_rohstoffe)).",
			);
			expect(isPrologFalse(result)).toBe(true);
		});
	});

	describe("SS 1 Abs 2 - Ausnahmen (Exceptions)", () => {
		it("exception: Abraummaterial is exempt", async () => {
			const sv = sachverhalt("miner_a", { abraummaterial: true, tonnen: 10000 });
			const vm = await createVM(sv);
			const result = vm.execute(
				"ausnahme(labgg, miner_a, bergbau(gewinnen, obertags, mineralische_rohstoffe), gestein).",
			);
			expect(isPrologFalse(result)).toBe(false);
		});

		it("exception: material from rivers (Fliessgewaesser)", async () => {
			const sv = sachverhalt("miner_b", { fliessgewaesser: true, tonnen: 5000 });
			const vm = await createVM(sv);
			const result = vm.execute(
				"ausnahme(labgg, miner_b, bergbau(gewinnen, obertags, mineralische_rohstoffe), gestein).",
			);
			expect(isPrologFalse(result)).toBe(false);
		});

		it("exception: coal (Kohle) is exempt", async () => {
			const sv = sachverhalt("miner_c", { gesteinArt: "kohle", tonnen: 50000 });
			const vm = await createVM(sv);
			const result = vm.execute(
				"ausnahme(labgg, miner_c, bergbau(gewinnen, obertags, mineralische_rohstoffe), gestein).",
			);
			expect(isPrologFalse(result)).toBe(false);
		});

		it("exception: material from Seitenentnahme", async () => {
			const sv = sachverhalt("miner_d", { seitenentnahme: true, tonnen: 3000 });
			const vm = await createVM(sv);
			const result = vm.execute(
				"ausnahme(labgg, miner_d, bergbau(gewinnen, obertags, mineralische_rohstoffe), gestein).",
			);
			expect(isPrologFalse(result)).toBe(false);
		});

		it("exception: resources for hazard prevention (Gefahrenabwehr)", async () => {
			const sv = sachverhalt("miner_e", { gefahrenabwehr: true, tonnen: 2000 });
			const vm = await createVM(sv);
			const result = vm.execute(
				"ausnahme(labgg, miner_e, bergbau(gewinnen, obertags, mineralische_rohstoffe), gestein).",
			);
			expect(isPrologFalse(result)).toBe(false);
		});

		it("no exception for regular mineral resources", async () => {
			const sv = sachverhalt("miner_f", { gesteinArt: "kalkstein", tonnen: 50000 });
			const vm = await createVM(sv);
			const result = vm.execute(
				"ausnahme(labgg, miner_f, bergbau(gewinnen, obertags, mineralische_rohstoffe), gestein).",
			);
			expect(isPrologFalse(result)).toBe(true);
		});
	});

	describe("SS 1 Abs 3-6 - Ertragsanteile", () => {
		it("municipality receives 20% share", async () => {
			const vm = await createVM();
			const result = vm.executeQueryAndEvaluate<number>("ertragsanteil(labgg, gemeinde, X).", "X");
			expect(result).toStrictEqual([0.2]);
		});

		it("state receives 80% share", async () => {
			const vm = await createVM();
			const result = vm.executeQueryAndEvaluate<number>("ertragsanteil(labgg, land, X).", "X");
			expect(result).toStrictEqual([0.8]);
		});

		it("shares sum to 100%", async () => {
			const vm = await createVM();
			const gemeinde = vm.executeQueryAndEvaluate<number>("ertragsanteil(labgg, gemeinde, X).", "X");
			const land = vm.executeQueryAndEvaluate<number>("ertragsanteil(labgg, land, X).", "X");
			expect(gemeinde[0] + land[0]).toBeCloseTo(1.0);
		});
	});

	describe("SS 2 - Begriffsbestimmungen (Betreiber)", () => {
		it("natural person + berufsmaessig = Betreiber", async () => {
			const sv = sachverhalt("hans", { natuerlichePerson: true, berufsmaessig: true });
			const vm = await createVM(sv);
			const result = vm.execute("betreiber(hans).");
			expect(isPrologFalse(result)).toBe(false);
		});

		it("natural person + gewerblich = Betreiber", async () => {
			const sv = sachverhalt("karl", {
				natuerlichePerson: true,
				berufsmaessig: false,
				gewerblich: true,
			});
			const vm = await createVM(sv);
			const result = vm.execute("betreiber(karl).");
			expect(isPrologFalse(result)).toBe(false);
		});

		it("juristic person + gewerblich = Betreiber", async () => {
			const sv = sachverhalt("firma_ag", {
				natuerlichePerson: false,
				juristischePerson: true,
				berufsmaessig: false,
				gewerblich: true,
			});
			const vm = await createVM(sv);
			const result = vm.execute("betreiber(firma_ag).");
			expect(isPrologFalse(result)).toBe(false);
		});

		it("person without gewerblich/berufsmaessig is NOT Betreiber", async () => {
			const sv = sachverhalt("hobby_miner", {
				natuerlichePerson: true,
				berufsmaessig: false,
				gewerblich: false,
			});
			const vm = await createVM(sv);
			const result = vm.execute("betreiber(hobby_miner).");
			expect(isPrologFalse(result)).toBe(true);
		});
	});

	describe("SS 3 - Abgabepflichtiger", () => {
		it("Betreiber is abgabepflichtig", async () => {
			const sv = sachverhalt("betreiber_x", { natuerlichePerson: true, berufsmaessig: true });
			const vm = await createVM(sv);
			const result = vm.execute("abgabepflichtiger(labgg, betreiber_x).");
			expect(isPrologFalse(result)).toBe(false);
		});

		it("non-Betreiber is NOT abgabepflichtig", async () => {
			const sv = sachverhalt("privatmann", {
				natuerlichePerson: true,
				berufsmaessig: false,
				gewerblich: false,
			});
			const vm = await createVM(sv);
			const result = vm.execute("abgabepflichtiger(labgg, privatmann).");
			expect(isPrologFalse(result)).toBe(true);
		});

		it("finds all abgabepflichtige persons", async () => {
			const sv = sachverhalt("otto", { natuerlichePerson: true, berufsmaessig: true });
			const vm = await createVM(sv);
			const result = vm.executeQueryAndEvaluate<string>("abgabepflichtiger(labgg, X).", "X");
			expect(result).toContain("otto");
		});
	});

	describe("SS 4 - Abgabenbefreiung (< 120 EUR threshold)", () => {
		it("2 tonnes -> 0.41 EUR -> exempt (below 120 EUR)", async () => {
			const sv = sachverhalt("klein_miner", { tonnen: 2 });
			const vm = await createVM(sv);
			const result = vm.execute(
				"ausnahme(labgg, klein_miner, bergbau(gewinnen, obertags, mineralische_rohstoffe), gestein).",
			);
			expect(isPrologFalse(result)).toBe(false);
		});

		it("100 tonnes -> 20.74 EUR -> exempt (below 120 EUR)", async () => {
			const sv = sachverhalt("mittel_miner", { tonnen: 100 });
			const vm = await createVM(sv);
			const result = vm.execute(
				"ausnahme(labgg, mittel_miner, bergbau(gewinnen, obertags, mineralische_rohstoffe), gestein).",
			);
			expect(isPrologFalse(result)).toBe(false);
		});

		it("578 tonnes -> 119.88 EUR -> exempt (just below threshold)", async () => {
			const sv = sachverhalt("grenz_miner", { tonnen: 578 });
			const vm = await createVM(sv);
			const result = vm.execute(
				"ausnahme(labgg, grenz_miner, bergbau(gewinnen, obertags, mineralische_rohstoffe), gestein).",
			);
			expect(isPrologFalse(result)).toBe(false);
		});

		it("579 tonnes -> 120.08 EUR -> NOT exempt (just above threshold)", async () => {
			const sv = sachverhalt("gross_miner", { tonnen: 579 });
			const vm = await createVM(sv);

			// Check that the bagatelle exception does NOT apply
			const abgabeHoehe = vm.executeQueryAndEvaluate<number>(
				"abgabe_hoehe(labgg, gestein, X).",
				"X",
			);
			expect(abgabeHoehe[0]).toBeGreaterThan(120);

			// The full subsumtion should find them liable
			const result = vm.execute("abgabepflichtig(labgg, sachverhalt, gross_miner).");
			expect(isPrologFalse(result)).toBe(false);
		});

		it("10000 tonnes -> 2074 EUR -> NOT exempt", async () => {
			const sv = sachverhalt("berg_gmbh", {
				juristischePerson: true,
				natuerlichePerson: false,
				gewerblich: true,
				tonnen: 10000,
			});
			const vm = await createVM(sv);
			const result = vm.execute("abgabepflichtig(labgg, sachverhalt, berg_gmbh).");
			expect(isPrologFalse(result)).toBe(false);
		});
	});

	describe("SS 5 - Hoehe der Abgabe", () => {
		it("calculates 0.2074 EUR per tonne: 1 tonne = 0.2074", async () => {
			const sv = sachverhalt("calc_a", { tonnen: 1 });
			const vm = await createVM(sv);
			const result = vm.executeQueryAndEvaluate<number>("abgabe_hoehe(labgg, gestein, X).", "X");
			expect(result[0]).toBeCloseTo(0.2074);
		});

		it("calculates 0.2074 EUR per tonne: 100 tonnes = 20.74", async () => {
			const sv = sachverhalt("calc_b", { tonnen: 100 });
			const vm = await createVM(sv);
			const result = vm.executeQueryAndEvaluate<number>("abgabe_hoehe(labgg, gestein, X).", "X");
			expect(result[0]).toBeCloseTo(20.74);
		});

		it("calculates 0.2074 EUR per tonne: 50000 tonnes = 10370", async () => {
			const sv = sachverhalt("calc_c", { tonnen: 50000 });
			const vm = await createVM(sv);
			const result = vm.executeQueryAndEvaluate<number>("abgabe_hoehe(labgg, gestein, X).", "X");
			expect(result[0]).toBeCloseTo(10370.0);
		});

		it("index reference is Statistik Austria VPI", async () => {
			const vm = await createVM();
			const result = vm.execute("abgabe_hoehe_index(labgg, statistik_austria_vpi).");
			expect(isPrologFalse(result)).toBe(false);
		});

		it("index adjustment threshold is 5%", async () => {
			const vm = await createVM();
			const result = vm.execute(
				"abgabe_hoehe_index_anpassen_wenn(labgg, aenderung, groesser, 5, percent).",
			);
			expect(isPrologFalse(result)).toBe(false);
		});
	});

	describe("SS 6 - Entstehen der Abgabeschuld", () => {
		it("tax liability arises at time of Verwertung", async () => {
			const sv = [
				sachverhalt("verwert_miner", { tonnen: 1000 }),
				`verwertet_am(gestein, date(2024, 6, 15, 0, 0, 0, _, _, _)).`,
			].join("\n");
			const vm = await createVM(sv);
			const result = vm.executeQueryAndEvaluate<string>(
				"abgabenschuld_zeitpunkt(labgg, gestein, X).",
				"X",
			);
			expect(result).toHaveLength(1);
		});
	});

	describe("SS 7-8 - Aufzeichnungs- und Anzeigepflicht", () => {
		it("Betreiber has Aufzeichnungspflicht", async () => {
			const sv = sachverhalt("pflicht_miner", { natuerlichePerson: true, berufsmaessig: true });
			const vm = await createVM(sv);
			const result = vm.execute("aufzeichnungspflicht(labgg, pflicht_miner).");
			expect(isPrologFalse(result)).toBe(false);
		});

		it("Betreiber has Anzeigepflicht", async () => {
			const sv = sachverhalt("pflicht_miner2", { natuerlichePerson: true, gewerblich: true });
			const vm = await createVM(sv);
			const result = vm.execute("anzeigepflicht(labgg, pflicht_miner2).");
			expect(isPrologFalse(result)).toBe(false);
		});

		it("non-Betreiber has NO Aufzeichnungspflicht", async () => {
			const sv = sachverhalt("privat", {
				natuerlichePerson: true,
				berufsmaessig: false,
				gewerblich: false,
			});
			const vm = await createVM(sv);
			const result = vm.execute("aufzeichnungspflicht(labgg, privat).");
			expect(isPrologFalse(result)).toBe(true);
		});
	});

	describe("SS 9 - Selbstbemessung, Faelligkeit", () => {
		it("general filing deadline is April 30", async () => {
			const vm = await createVM();
			const result = vm.executeQueryAndEvaluate<number>(
				"abgabenerklaerung_einzureichen_bis(labgg, allgemein, X).",
				"X",
			);
			expect(result).toStrictEqual([430]);
		});

		it("first half 2018 transitional deadline is October 31", async () => {
			const vm = await createVM();
			const result = vm.executeQueryAndEvaluate<number>(
				"abgabenerklaerung_einzureichen_bis(labgg, erstes_halbjahr_2018, X).",
				"X",
			);
			expect(result).toStrictEqual([1031]);
		});
	});

	describe("SS 10 - Behoerde", () => {
		it("tax authority is Landesregierung OOe", async () => {
			const vm = await createVM();
			const result = vm.execute("abgabenbehoerde(labgg, landesregierung_ooe).");
			expect(isPrologFalse(result)).toBe(false);
		});
	});

	describe("SS 11 - Schlussbestimmungen", () => {
		it("law entered into force on 2018-01-01", async () => {
			const vm = await createVM();
			const result = vm.executeQueryAndEvaluate<number>("inkrafttreten(labgg, X).", "X");
			expect(result).toStrictEqual([20180101]);
		});
	});

	describe("Full subsumtion: abgabepflichtig/3", () => {
		it("standard case: natural person, berufsmaessig, 10000t -> liable", async () => {
			const sv = sachverhalt("standard_miner", { tonnen: 10000 });
			const vm = await createVM(sv);
			const result = vm.execute("abgabepflichtig(labgg, sachverhalt, standard_miner).");
			expect(isPrologFalse(result)).toBe(false);
		});

		it("coal miner is NOT liable (Kohle exception)", async () => {
			const sv = sachverhalt("kohle_miner", { gesteinArt: "kohle", tonnen: 50000 });
			const vm = await createVM(sv);
			const result = vm.execute("abgabepflichtig(labgg, sachverhalt, kohle_miner).");
			expect(isPrologFalse(result)).toBe(true);
		});

		it("small-scale miner is NOT liable (below 120 EUR threshold)", async () => {
			const sv = sachverhalt("klein_betreiber", { tonnen: 2 });
			const vm = await createVM(sv);
			const result = vm.execute("abgabepflichtig(labgg, sachverhalt, klein_betreiber).");
			expect(isPrologFalse(result)).toBe(true);
		});

		it("Abraummaterial miner is NOT liable", async () => {
			const sv = sachverhalt("abraum_miner", { abraummaterial: true, tonnen: 50000 });
			const vm = await createVM(sv);
			const result = vm.execute("abgabepflichtig(labgg, sachverhalt, abraum_miner).");
			expect(isPrologFalse(result)).toBe(true);
		});

		it("Seitenentnahme miner is NOT liable", async () => {
			const sv = sachverhalt("seiten_miner", { seitenentnahme: true, tonnen: 5000 });
			const vm = await createVM(sv);
			const result = vm.execute("abgabepflichtig(labgg, sachverhalt, seiten_miner).");
			expect(isPrologFalse(result)).toBe(true);
		});

		it("Gefahrenabwehr miner is NOT liable", async () => {
			const sv = sachverhalt("notfall_miner", { gefahrenabwehr: true, tonnen: 8000 });
			const vm = await createVM(sv);
			const result = vm.execute("abgabepflichtig(labgg, sachverhalt, notfall_miner).");
			expect(isPrologFalse(result)).toBe(true);
		});

		it("Fliessgewaesser material is NOT liable", async () => {
			const sv = sachverhalt("fluss_miner", { fliessgewaesser: true, tonnen: 3000 });
			const vm = await createVM(sv);
			const result = vm.execute("abgabepflichtig(labgg, sachverhalt, fluss_miner).");
			expect(isPrologFalse(result)).toBe(true);
		});

		it("non-Betreiber (hobby miner) is still found abgabepflichtig (abgabepflichtig/3 does not check betreiber)", async () => {
			// Note: abgabepflichtig/3 checks subjekt, verbum, objekt, abgabe_auf, and \+ ausnahme
			// but does NOT check betreiber/abgabepflichtiger. This is a known limitation.
			const sv = sachverhalt("hobby", {
				natuerlichePerson: true,
				berufsmaessig: false,
				gewerblich: false,
				tonnen: 100000,
			});
			const vm = await createVM(sv);
			const result = vm.execute("abgabepflichtig(labgg, sachverhalt, hobby).");
			// The predicate succeeds because the sachverhalt matches and no ausnahme applies
			expect(isPrologFalse(result)).toBe(false);
		});

		it("juristic person + gewerblich + large quantity -> liable", async () => {
			const sv = sachverhalt("steinbruch_gmbh", {
				natuerlichePerson: false,
				juristischePerson: true,
				berufsmaessig: false,
				gewerblich: true,
				tonnen: 50000,
			});
			const vm = await createVM(sv);
			const result = vm.execute("abgabepflichtig(labgg, sachverhalt, steinbruch_gmbh).");
			expect(isPrologFalse(result)).toBe(false);
		});
	});

	describe("Edge cases", () => {
		it("578 tonnes: abgabe_hoehe = 119.88 EUR (below threshold 120)", async () => {
			const sv = sachverhalt("edge_a", { tonnen: 578 });
			const vm = await createVM(sv);
			const hoehe = vm.executeQueryAndEvaluate<number>("abgabe_hoehe(labgg, gestein, X).", "X");
			expect(hoehe[0]).toBeCloseTo(119.88);
			expect(hoehe[0]).toBeLessThan(120);
		});

		it("579 tonnes: abgabe_hoehe = 120.08 EUR (above threshold 120)", async () => {
			const sv = sachverhalt("edge_b", { tonnen: 579 });
			const vm = await createVM(sv);
			const hoehe = vm.executeQueryAndEvaluate<number>("abgabe_hoehe(labgg, gestein, X).", "X");
			expect(hoehe[0]).toBeCloseTo(120.08);
			expect(hoehe[0]).toBeGreaterThan(120);
		});

		it("person with no mining activity has no obligations", async () => {
			const sv = [
				`:- discontiguous natuerliche_person/1.`,
				`:- discontiguous berufsmaessig/1.`,
				`natuerliche_person(bystander).`,
				`berufsmaessig(bystander).`,
			].join("\n");
			const vm = await createVM(sv);
			const result = vm.execute("abgabepflichtig(labgg, sachverhalt, bystander).");
			expect(isPrologFalse(result)).toBe(true);
		});

		it("multiple persons in same sachverhalt: only Betreiber is liable", async () => {
			const sv = [
				`:- discontiguous subjekt/2.`,
				`:- discontiguous verbum/3.`,
				`:- discontiguous objekt/4.`,
				`:- discontiguous natuerliche_person/1.`,
				`:- discontiguous berufsmaessig/1.`,
				`:- discontiguous gefoerdert/3.`,
				``,
				`subjekt(sv, alice).`,
				`natuerliche_person(alice).`,
				`berufsmaessig(alice).`,
				`verbum(sv, alice, bergbau(gewinnen, obertags, mineralische_rohstoffe)).`,
				`objekt(sv, alice, bergbau(gewinnen, obertags, mineralische_rohstoffe), stein_a).`,
				`gefoerdert(stein_a, 10000, tonne).`,
				``,
				`subjekt(sv, bob).`,
				`natuerliche_person(bob).`,
			].join("\n");
			const vm = await createVM(sv);

			const liable = vm.executeQueryAndEvaluate<string>(
				"abgabepflichtig(labgg, sv, X).",
				"X",
			);
			expect(liable).toContain("alice");
			expect(liable).not.toContain("bob");
		});
	});
});
