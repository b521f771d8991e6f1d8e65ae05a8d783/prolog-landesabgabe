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

/**
 * Abstract base class representing a Prolog "Sachverhalt" (case or scenario).
 * 
 * This class defines the contract for managing persons, their associated actions (Handlung),
 * and serialization to Prolog syntax. Implementations should provide concrete logic for
 * handling the relationships and data relevant to a legal or logical scenario.
 * 
 * @remarks
 * - `sacherhaltId`: Unique identifier for the Sachverhalt.
 * - `persons`: List of all persons involved in the Sachverhalt.
 * - `personsWithAssociatedHandlung`: Mapping of persons to their associated actions.
 * - `addSovereignPerson`: Adds a sovereign person to the Sachverhalt.
 * - `addToJoinTable`: Associates a person with a Handlung (action).
 * - `serialize2Prolog`: Serializes the Sachverhalt to a Prolog-compatible string.
 */
export abstract class PrologSachverhalt {
    public abstract get sacherhaltId(): string;
    public abstract get persons(): PrologPerson[];
    public abstract get personsWithAssociatedHandlung(): Map<PrologPerson, PrologHandlung[]>;
    public abstract addSovereignPerson(sp: PrologPerson): void;
    public abstract addToJoinTable(p: PrologPerson, h: PrologHandlung): void;
    abstract serialize2Prolog(): string;
};

/**
 * Abstract base class representing a person in the Prolog logic system.
 * 
 * Implementations must provide unique identification and personal details,
 * as well as methods to serialize the person into Prolog format.
 *
 * @remarks
 * - The class enforces the implementation of properties for person ID, first name (`vorname`), last name (`nachname`), and age (`alter`).
 * - Two overloaded `serialize2Prolog` methods are required for converting the person to a Prolog representation, either by sachverhaltsID or by a `PrologSachverhalt` object.
 */
export abstract class PrologPerson {
    public abstract get personId(): string;

    public abstract get vorname(): string;
    public abstract get nachname(): string;
    public abstract get alter(): number;
    abstract serialize2Prolog(sachverhaltsID: string): string;
    abstract serialize2Prolog(sachverhalt: PrologSachverhalt): string;
};

/**
 * Abstract base class representing a Prolog action ("Handlung").
 * 
 * Subclasses must implement properties and methods for unique identification,
 * date, visualization, and serialization to Prolog format.
 * 
 * @remarks
 * - `handlungId`: Unique identifier for the action.
 * - `date`: The date associated with the action.
 * - `visualization`: Returns a JSX element representing the action visually.
 * - `serialize2Prolog(sachverhaltId, personId)`: Serializes the action to a Prolog string using IDs.
 * - `serialize2Prolog(sachverhalt, person)`: Serializes the action to a Prolog string using object references.
 */
export abstract class PrologHandlung {
    public abstract get handlungId(): string;
    public abstract get date(): Date;
    abstract get visualization(): JSX.Element;
    abstract serialize2Prolog(sachverhaltId: string, personId: string): string;
    abstract serialize2Prolog(sachverhalt: PrologSachverhalt, person: PrologHandlung): string;
};
