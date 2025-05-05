import { Prolog } from "scryer";
import { SwiPrologVM } from "./PrologVM/PrologVM";
import {add} from "../../../npm-pkgs/logic-kit-rust";

console.log("Hello from the inside", add(1n, 2n));
console.log(Prolog.name);
const i = await SwiPrologVM.initPrologVM();
console.log(i.getFactBase());

console.log("aefe");
function doStuff(i: string) { }