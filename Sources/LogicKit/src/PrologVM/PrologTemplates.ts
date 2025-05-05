import { v4 as uuidv4 } from 'uuid';

export function generateUUID(id: string) {
    return `${id}_${uuidv4().replaceAll("-", "")}`;
}

export const DISCONTIGUOUS_TAGS = [
    "verbum/3",
    "nachname/2",
    "vorname/2",
    "natuerliche_person/1",
    "alter/2",
    "subjekt/2",
    "objekt/4",
    "verwertet_am/2",
    "gefoerdert/3"
];

export abstract class PrologSachverhalt {
    public abstract get sacherhaltId(): string;
    public abstract get persons(): PrologPerson[];
    public abstract get personsWithAssociatedHandlung(): Map<PrologPerson, PrologHandlung[]>;
    public abstract addSovereignPerson(sp: PrologPerson): void;
    public abstract addToJoinTable(p: PrologPerson, h: PrologHandlung): void;
    abstract serialize2Prolog(): string;
};

export abstract class PrologPerson {
    public abstract get personId(): string;

    public abstract get vorname(): string;
    public abstract get nachname(): string;
    public abstract get alter(): number;
    abstract serialize2Prolog(sachverhaltsID: string): string;
    abstract serialize2Prolog(sachverhalt: PrologSachverhalt): string;
};

export abstract class PrologHandlung {
    public abstract get handlungId(): string;
    public abstract get date(): Date;
    abstract get visualization(): JSX.Element;
    abstract serialize2Prolog(sachverhaltId: string, personId: string): string;
    abstract serialize2Prolog(sachverhalt: PrologSachverhalt, person: PrologHandlung): string;
};
