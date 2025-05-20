import { Prolog } from "scryer";
import { SwiPrologVM } from "./PrologVM/PrologVM";

console.log(Prolog.name);
const i = await SwiPrologVM.initPrologVM();
console.log(i.getFactBase());

console.log("aefe");