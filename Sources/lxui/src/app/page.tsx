import Image from "next/image";
import { useId, useRef } from "react";
import { v4 as uuidv4 } from 'uuid';

function OutputDiv() {
  return <></>;
}

function Form() {
  return <></>
}

interface PrologFragment {
  serialize2Prolog(): string;
}

function generateUUID(id: string) {
  return `${id}_${uuidv4().replaceAll("-", "")}`;
}

const GESTEIN_ID = "gestein";
const PERSON_ID = "person";

class LandesabgabeHandlung implements PrologFragment {
  person_id: string;
  sachverhalt_id: string;
  gefördert?: number;
  date: Date;
  einheit: string = "tonne";

  constructor(sachverhalt_id: string, person_id: string, date: Date, gefördert?: number) {
    this.sachverhalt_id = sachverhalt_id;
    this.person_id = person_id;
    this.gefördert = gefördert;
    this.date = date;
  }

  serialize2Prolog(): string {
    const uuidWithPrefix = generateUUID(GESTEIN_ID);

    return `
      verbum(${this.sachverhalt_id}, ${this.person_id}, bergbau(gewinnen, obertags, mineralische_rohstoffe)).
      objekt(this.sachverhalt_id, ${this.person_id}, bergbau(gewinnen, obertags, mineralische_rohstoffe), ${uuidWithPrefix}).
      ${this.gefördert ? `gefoerdert(${uuidWithPrefix}, ${this.gefördert!}, ${this.einheit}).` : ""}
      verwertet_am(${uuidWithPrefix}, date(${this.date.getFullYear()}, ${this.date.getMonth()}, ${this.date.getDay()}, 0, 0, 0, Off, TZ, DST)).
    `; // TODO Stunde und Minute übernehmen
  }
}

class LandesabgabePerson implements PrologFragment {
  sachverhalt: string;
  vorname: string;
  nachname: string;
  alter: number;
  berufsmäßig: boolean;

  constructor(sachverhalt: string, vorname: string, nachname: string, alter: number, berufsmäßig: boolean = true) {
    this.sachverhalt = sachverhalt;
    this.vorname = vorname;
    this.nachname = nachname;
    this.alter = alter;
    this.berufsmäßig = berufsmäßig;
  }

  serialize2Prolog(): string {
    const uuidWithPrefix = generateUUID(PERSON_ID);

    return `
      subjekt(${this.sachverhalt}, ${uuidWithPrefix}).
      vorname(${uuidWithPrefix}, "${this.vorname}").
      nachname(${uuidWithPrefix}, "${this.nachname}").
      natuerliche_person(${uuidWithPrefix}).
      alter(${uuidWithPrefix}, ${this.alter}).
      ${this.berufsmäßig ? "" : `berufsmaessig(${uuidWithPrefix}).`}
    `;
  }
}

export default function Home() {
  let i = new LandesabgabePerson("sachverhalt", "vorname", "nachname", 23);
  console.log(i.serialize2Prolog());
  return <>
    <main className="flex flex-col gap-8 row-start-2 items-center sm:items-start">
      <Form>

      </Form>

      <OutputDiv>

      </OutputDiv>
    </main>
  </>;
}
