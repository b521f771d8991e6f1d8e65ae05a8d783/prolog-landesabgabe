import labggRaw from "../../Sources/Corpus/labgg.pl?raw";
import mineralrohstoffgesetzRaw from "../../Sources/Corpus/stdlib/mineralrohstoffgesetz.pl?raw";
import bergbauRaw from "../../Sources/Corpus/stdlib/bergbau.pl?raw";
import abgabeRaw from "../../Sources/Corpus/stdlib/abgabe.pl?raw";
import gebietskoerperschaftenRaw from "../../Sources/Corpus/stdlib/gebietskoerperschaften.pl?raw";

export const labgg = labggRaw;
export const mineralrohstoffgesetz = mineralrohstoffgesetzRaw;
export const bergbau = bergbauRaw;
export const abgabe = abgabeRaw;
export const gebietskoerperschaften = gebietskoerperschaftenRaw;

export const allLaws = [labgg, mineralrohstoffgesetz, bergbau, abgabe, gebietskoerperschaften].join("\n");
