import { v4 as uuidv4 } from 'uuid';

function generateUUID(id: string) {
    return `${id}_${uuidv4().replaceAll("-", "")}`;
}

const GESTEIN_ID = "gestein";
const PERSON_ID = "person";
const SACHVERHALT_ID = "sachverhalt";

export class LandesabgabeSachverhalt {
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
        return this.sovereignPersons;
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
        function joinWithNewLine(a: string, b: string) {
            return `${a}\n${b}`;
        }

        return "% Sachverhalt" + this.personsWithAssociatedHandlung.keys().reduce((p: string, person: LandesabgabePerson) => {
            const handlungen = this.personsWithAssociatedHandlung.get(person) ?? [];
            return p + joinWithNewLine(person.serialize2Prolog(this.sacherhaltId), handlungen.reduce((p, i: LandesabgabeHandlung) =>
                joinWithNewLine(p, i.serialize2Prolog(this.sacherhaltId, person.personId)), ""));
        }, "");
    }
}

export class LandesabgabePerson {
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

    serialize2Prolog(sachverhaltsID: string): string {
        return `
        % Person
        subjekt(${sachverhaltsID}, ${this.personId}).
        vorname(${this.personId}, "${this._vorname}").
        nachname(${this.personId}, "${this._nachname}").
        natuerliche_person(${this.personId}).
        alter(${this.personId}, ${this._alter}).
        ${this._berufsmäßig ? "" : `berufsmaessig(${this.personId}).`}
        `;
    }
}

export class LandesabgabeHandlung {
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

    serialize2Prolog(sachverhaltId: string, personId: string): string {
        return `
        % Handlung
        verbum(${sachverhaltId}, ${personId}, bergbau(gewinnen, obertags, mineralische_rohstoffe)).
        objekt(${sachverhaltId}, ${personId}, bergbau(gewinnen, obertags, mineralische_rohstoffe), ${this.uuidWithPrefix}).
        ${this.gefördert ? `gefoerdert(${this.uuidWithPrefix}, ${this.gefördert!}, ${this.einheit}).` : ""}
        verwertet_am(${this.uuidWithPrefix}, date(${this.date.getFullYear()}, ${this.date.getMonth()}, ${this.date.getDay()}, 0, 0, 0, Off, TZ, DST)).
        `; // TODO Stunde und Minute übernehmen*/
    }
}