import { v4 as uuidv4 } from 'uuid';
import { V } from 'vitest/dist/chunks/reporters.D7Jzd9GS';

interface PrologFragment {
    serialize2Prolog(): string;
}

function generateUUID(id: string) {
    return `${id}_${uuidv4().replaceAll("-", "")}`;
}

const GESTEIN_ID = "gestein";
const PERSON_ID = "person";
const SACHVERHALT_ID = "sachverhalt";

export class LandesabgabeSachverhalt implements PrologFragment {
    private _sachverhalt_id: string;
    private _sovereignPersons: LandesabgabePerson[];
    private _joinTable: [LandesabgabePerson, LandesabgabeHandlung][];

    constructor(sachverhaltsID = generateUUID(SACHVERHALT_ID),
        sovereignPersons: LandesabgabePerson[] = [],
        umgesetzteHandlung: [LandesabgabePerson, LandesabgabeHandlung][] = []) {
        this._sachverhalt_id = sachverhaltsID;
        this._sovereignPersons = sovereignPersons;
        this._joinTable = umgesetzteHandlung;
    }

    public get sacherhaltId(): string {
        return this._sachverhalt_id;
    }

    public get sovereignPersons() {
        return this._sovereignPersons;
    }

    public addSovereignPerson(sp: LandesabgabePerson) {
        return this._sovereignPersons.push(sp);
    }

    public get joinTable() {
        return this._joinTable;
    }

    public addToJoinTable(p: LandesabgabePerson, h: LandesabgabeHandlung) {
        this._joinTable.push([p, h]);
    }

    public get persons() {
        return [...this.sovereignPersons, ...this.joinTable.map((x) => x[0])];
    }

    public get handlungen() {
        return this.joinTable.map((x) => x[1]);
    }

    public get personsWithAssociatedHandlung(): Map<LandesabgabePerson, LandesabgabeHandlung[]> {
        let ret = new Map<LandesabgabePerson, LandesabgabeHandlung[]>();

        // non-sovereign persons are added later anyway
        for (const i of this.sovereignPersons) {
            ret.set(i, []);
        }

        for (const i of this.joinTable) {
            const person: LandesabgabePerson = i[0];
            const handlung: LandesabgabeHandlung = i[1];

            ret.set(person, [...(ret.get(person) ?? []), handlung]);
        }

        return ret;
    }

    serialize2Prolog(): string {
        return "% Sachverhalt";
    }
}

export class LandesabgabePerson implements PrologFragment {
    private _vorname: string;
    private _nachname: string;
    private _alter: number;
    private _berufsmäßig: boolean;
    private _personId: string;

    constructor(vorname: string,
        nachname: string,
        alter: number,
        berufsmäßig: boolean = true) {
        this._vorname = vorname;
        this._nachname = nachname;
        this._alter = alter;
        this._berufsmäßig = berufsmäßig;
        this._personId = generateUUID(PERSON_ID);
    }

    public convert2JSON() {
        console.log(this);
        return JSON.stringify(this);
    }

    public get personId() {
        return this._personId;
    }

    public get vorname(): string {
        return this._vorname;
    }

    public get nachname(): string {
        return this._nachname;
    }

    public get alter(): number {
        return this._alter;
    }

    public get berufsmäßig(): boolean {
        return this._berufsmäßig;
    }

    public get person_id(): string {
        return this._personId;
    }

    serialize2Prolog(): string {
        return "";
        /*
        return `% Person
        subjekt(${this._sachverhalt.sacherhaltId}, ${this._person_id}).
        vorname(${this._person_id}, "${this._vorname}").
        nachname(${this._person_id}, "${this._nachname}").
        natuerliche_person(${this._person_id}).
        alter(${this._person_id}, ${this._alter}).
        ${this._berufsmäßig ? "" : `berufsmaessig(${this._person_id}).`}
        `;*/
    }
}

export class LandesabgabeHandlung implements PrologFragment {
    private _gefördert?: number;
    private _date: Date;
    private _einheit: string = "tonne";
    private _uuidWithPrefix: string;

    constructor(date: Date, gefördert?: number) {
        this._gefördert = gefördert;
        this._date = date;
        this._uuidWithPrefix = generateUUID(GESTEIN_ID);
    }

    public get gefördert(): number | undefined {
        return this._gefördert;
    }

    public get date(): Date {
        return this._date;
    }

    public get einheit(): string {
        return this._einheit;
    }

    public get uuidWithPrefix(): string {
        return this._uuidWithPrefix;
    }

    serialize2Prolog(): string {
        return "";/*
        return `
        % Verbum
        verbum(${this.sachverhalt.sacherhaltId}, ${this.person.personId}, bergbau(gewinnen, obertags, mineralische_rohstoffe)).
        objekt(${this.sachverhalt.sacherhaltId}, ${this.person.personId}, bergbau(gewinnen, obertags, mineralische_rohstoffe), ${this.uuidWithPrefix}).
        ${this.gefördert ? `gefoerdert(${this.uuidWithPrefix}, ${this.gefördert!}, ${this.einheit}).` : ""}
        verwertet_am(${this.uuidWithPrefix}, date(${this.date.getFullYear()}, ${this.date.getMonth()}, ${this.date.getDay()}, 0, 0, 0, Off, TZ, DST)).
      `; // TODO Stunde und Minute übernehmen*/
    }
}