import labggRaw from "../../corpus/labgg.pl?raw";
import mineralrohstoffgesetzRaw from "../../corpus/stdlib/mineralrohstoffgesetz.pl?raw";
import bergbauRaw from "../../corpus/stdlib/bergbau.pl?raw";
import abgabeRaw from "../../corpus/stdlib/abgabe.pl?raw";
import gebietskoerperschaftenRaw from "../../corpus/stdlib/gebietskoerperschaften.pl?raw";

export const labgg = labggRaw;
export const mineralrohstoffgesetz = mineralrohstoffgesetzRaw;
export const bergbau = bergbauRaw;
export const abgabe = abgabeRaw;
export const gebietskoerperschaften = gebietskoerperschaftenRaw;

export const allLaws = [labgg, mineralrohstoffgesetz, bergbau, abgabe, gebietskoerperschaften].join("\n");
