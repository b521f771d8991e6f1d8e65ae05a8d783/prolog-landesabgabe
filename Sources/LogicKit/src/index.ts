import {add} from "../../../npm-pkgs/LogicKit";
import { Prolog } from "scryer";
import { PrologVM } from "./PrologVM/PrologVM.ts";

console.log("Hello from the inside", add(1, 2));
console.log("Hello from scryer", Prolog.toString());
console.log("Hello from SWI", PrologVM.initFromArray([]));

function doStuff(i: string) { }