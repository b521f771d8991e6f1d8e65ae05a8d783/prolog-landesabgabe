import { describe, it, expect } from "vitest";

import { SwiPrologVM } from "./SwiPrologVM";
import { PrologFile } from "./PrologFileSystem";

describe("PrologVM", () => {
	it("simple variable extraction", async () => {
		const pvm = await SwiPrologVM.initFromArray([
			PrologFile.fromPrologText(
				"human(elon_musk). alien(that_green_thing_over_there). ",
			),
		]);
		const result = pvm.executeQueryAndEvaluate<string>("human(X).", "X");
		expect(result).toStrictEqual(["elon_musk"]);
	});

	it("extract a variable with multiple values", async () => {
		const pvm = await SwiPrologVM.initFromArray([
			PrologFile.fromPrologText(
				"human(elon_musk). human(sebastian_kurz). alien(that_green_thing_over_there).",
			),
		]);
		const result = pvm.executeQueryAndEvaluate<string>("human(X).", "X");
		expect(result).toStrictEqual(["elon_musk", "sebastian_kurz"]);
	});

	it("multiple variables with negation", async () => {
		const pvm = await SwiPrologVM.initFromArray([
			PrologFile.fromPrologText(
				"human(elon_musk). human(sebastian_kurz). robot(wall_e). not_human(X) :- robot(X).",
			),
		]);

		const result = pvm.executeQueryAndEvaluateVariables([
			["human(X)", "X"],
			["not_human(Y)", "Y"],
		]);

		expect(result).toStrictEqual([
			{
				name: "X",
				values: ["elon_musk", "sebastian_kurz"],
			},
			{
				name: "Y",
				values: ["wall_e"],
			},
		]);
	});

	it("multiple variables with relationships", async () => {
		const pvm = await SwiPrologVM.initFromArray([
			PrologFile.fromPrologText(
				"parent(john,mary). parent(john,bob). parent(mary,alex). grandparent(X,Y) :- parent(X,Z), parent(Z,Y).",
			),
		]);

		const result = pvm.executeQueryAndEvaluateVariables([
			["parent(john,X)", "X"],
			["grandparent(john,Y)", "Y"],
		]);

		expect(result).toStrictEqual([
			{
				name: "X",
				values: ["mary", "bob"],
			},
			{
				name: "Y",
				values: ["alex"],
			},
		]);
	});

	it("variables with empty results", async () => {
		const pvm = await SwiPrologVM.initFromArray([
			PrologFile.fromPrologText("human(elon_musk)."),
			PrologFile.fromPrologText("robot(wall_e)."),
		]);

		const result = pvm.executeQueryAndEvaluateVariables([
			["human(X)", "X"],
			["alien(Y)", "Y"],
			["robot(Z)", "Z"],
		]);

		expect(result).toStrictEqual([
			{
				name: "X",
				values: ["elon_musk"],
			},
			{
				name: "Y",
				values: [],
			},
			{
				name: "Z",
				values: ["wall_e"],
			},
		]);
	});

	it("multiple rules and facts across files", async () => {
		const pvm = await SwiPrologVM.initFromArray([
			PrologFile.fromPrologText("student(john). student(mary)."),
			PrologFile.fromPrologText("teacher(prof_smith). teacher(prof_jones)."),
			PrologFile.fromPrologText(
				"teaches(prof_smith, math). teaches(prof_jones, history).",
			),
			PrologFile.fromPrologText(
				"studies(X,Y) :- student(X), teaches(Z,Y), teacher(Z).",
			),
		]);

		const result = pvm.executeQueryAndEvaluateVariables([
			["student(X)", "X"],
			["teacher(Y)", "Y"],
			["studies(john,Z)", "Z"],
		]);

		expect(result).toStrictEqual([
			{
				name: "X",
				values: ["john", "mary"],
			},
			{
				name: "Y",
				values: ["prof_smith", "prof_jones"],
			},
			{
				name: "Z",
				values: ["math", "history"],
			},
		]);
	});

	it("complex relationships with multiple predicates", async () => {
		const pvm = await SwiPrologVM.initFromArray([
			PrologFile.fromPrologText("likes(john,pizza). likes(mary,pasta)."),
			PrologFile.fromPrologText(
				"cooking_skill(john,beginner). cooking_skill(mary,expert).",
			),
			PrologFile.fromPrologText(
				"can_cook(X,Y) :- likes(X,Y), cooking_skill(X,expert).",
			),
			PrologFile.fromPrologText(
				"wants_to_learn(X,Y) :- likes(X,Y), cooking_skill(X,beginner).",
			),
		]);

		const result = pvm.executeQueryAndEvaluateVariables([
			["can_cook(X,Y)", "X"],
			["wants_to_learn(john,Z)", "Z"],
		]);

		expect(result).toStrictEqual([
			{
				name: "X",
				values: ["mary"],
			},
			{
				name: "Z",
				values: ["pizza"],
			},
		]);
	});
});
