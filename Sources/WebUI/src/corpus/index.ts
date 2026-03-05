import labggRaw from "../../../Corpus/labgg.pl?raw";
import mineralrohstoffgesetzRaw from "../../../Corpus/stdlib/mineralrohstoffgesetz.pl?raw";
import bergbauRaw from "../../../Corpus/stdlib/bergbau.pl?raw";
import abgabeRaw from "../../../Corpus/stdlib/abgabe.pl?raw";
import gebietskoerperschaftenRaw from "../../../Corpus/stdlib/gebietskoerperschaften.pl?raw";

export const labgg = labggRaw;
export const mineralrohstoffgesetz = mineralrohstoffgesetzRaw;
export const bergbau = bergbauRaw;
export const abgabe = abgabeRaw;
export const gebietskoerperschaften = gebietskoerperschaftenRaw;

export const allLaws = [labgg, mineralrohstoffgesetz, bergbau, abgabe, gebietskoerperschaften].join("\n");
