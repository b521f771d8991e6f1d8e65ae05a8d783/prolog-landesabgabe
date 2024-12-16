import { v4 as uuidv4 } from 'uuid';

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

    constructor() {
        this._sachverhalt_id = generateUUID(SACHVERHALT_ID);
    }

    public get sacherhaltId(): string {
        return this._sachverhalt_id;
    }

    serialize2Prolog(): string {
        return `% Sachverhalt`;
    }
}

export class LandesabgabeHandlung implements PrologFragment {
    private _sachverhalt: LandesabgabeSachverhalt;
    private _person: LandesabgabePerson;
    private _gefördert?: number;
    private _date: Date;
    private _einheit: string = "tonne";
    private _uuidWithPrefix: string;

    constructor(sachverhalt_id: LandesabgabeSachverhalt, person: LandesabgabePerson, date: Date, gefördert?: number) {
        this._sachverhalt = sachverhalt_id;
        this._person = person;
        this._gefördert = gefördert;
        this._date = date;
        this._uuidWithPrefix = generateUUID(GESTEIN_ID);
    }

    public get sachverhalt(): LandesabgabeSachverhalt {
        return this._sachverhalt;
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

    public get person(): LandesabgabePerson {
        return this._person;
    }

    public get uuidWithPrefix(): string {
        return this._uuidWithPrefix;
    }

    serialize2Prolog(): string {
        return `
        % Verbum
        verbum(${this.sachverhalt.sacherhaltId}, ${this.person.personId}, bergbau(gewinnen, obertags, mineralische_rohstoffe)).
        objekt(${this.sachverhalt.sacherhaltId}, ${this.person.personId}, bergbau(gewinnen, obertags, mineralische_rohstoffe), ${this.uuidWithPrefix}).
        ${this.gefördert ? `gefoerdert(${this.uuidWithPrefix}, ${this.gefördert!}, ${this.einheit}).` : ""}
        verwertet_am(${this.uuidWithPrefix}, date(${this.date.getFullYear()}, ${this.date.getMonth()}, ${this.date.getDay()}, 0, 0, 0, Off, TZ, DST)).
      `; // TODO Stunde und Minute übernehmen
    }
}

export class LandesabgabePerson implements PrologFragment {
    private _sachverhalt: LandesabgabeSachverhalt;
    private _vorname: string;
    private _nachname: string;
    private _alter: number;
    private _berufsmäßig: boolean;
    private _person_id: string;

    constructor(sachverhalt: LandesabgabeSachverhalt, vorname: string, nachname: string, alter: number, berufsmäßig: boolean = true) {
        this._sachverhalt = sachverhalt;
        this._vorname = vorname;
        this._nachname = nachname;
        this._alter = alter;
        this._berufsmäßig = berufsmäßig;
        this._person_id = generateUUID(PERSON_ID);
    }

    public get personId() {
        return this._person_id;
    }

    public get sachverhalt(): LandesabgabeSachverhalt {
        return this._sachverhalt;
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
        return this._person_id;
    }

    serialize2Prolog(): string {
        return `
        % Person
        subjekt(${this._sachverhalt.sacherhaltId}, ${this._person_id}).
        vorname(${this._person_id}, "${this._vorname}").
        nachname(${this._person_id}, "${this._nachname}").
        natuerliche_person(${this._person_id}).
        alter(${this._person_id}, ${this._alter}).
        ${this._berufsmäßig ? "" : `berufsmaessig(${this._person_id}).`}
      `;
    }
}