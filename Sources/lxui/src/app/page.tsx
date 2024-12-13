import Image from "next/image";
import { useId, useRef } from "react";
import { v4 as uuidv4 } from 'uuid';

function OutputDiv() {
  return <></>;
}

function Form() {
  return <></>
}

`
subjekt(sachverhalt, max_mustermann).
vorname(max_mustermann, "Max").
nachname(max_mustermann, "Mustermann").
natuerliche_person(max_mustermann).
berufsmaessig(max_mustermann).

verbum(sachverhalt, max_mustermann, bergbau(gewinnen, obertags, mineralische_rohstoffe)).
objekt(sachverhalt, max_mustermann, bergbau(gewinnen, obertags, mineralische_rohstoffe), mein_gestein).
gefoerdert(mein_gestein, 2, tonne).
verwertet_am(mein_gestein, date(2024, 11, 12, 0, 0, 0, Off, TZ, DST)).`;

interface PrologFragment {
  serialize(): string;
}

class LandesabgabePerson implements PrologFragment {
  sachverhalt: string;
  vorname: string;
  nachname: string;
  alter: number;

  constructor(sachverhalt: string, vorname: string, nachname: string, alter: number) {
    this.sachverhalt = sachverhalt;
    this.vorname = vorname;
    this.nachname = nachname;
    this.alter = alter;
  }

  serialize(): string {
    const uuid: string = uuidv4();
    const uuidWithPrefx = `sachverhalt_${uuid.replaceAll("-", "")}`;

    return `
      subjekt(${this.sachverhalt}, ${uuidWithPrefx}).
      vorname(${uuidWithPrefx}, "${this.vorname}").
      nachname(${uuidWithPrefx}, "${this.nachname}").
      natuerliche_person(${uuidWithPrefx}).
      alter(${uuidWithPrefx}, ${this.alter}).
    `;
  }
}

export default function Home() {
  let i = new LandesabgabePerson("sachverhalt", "vorname", "nachname", 23);
  console.log(i.serialize());
  return <>
    <main className="flex flex-col gap-8 row-start-2 items-center sm:items-start">
      <Form>

      </Form>

      <OutputDiv>

      </OutputDiv>
    </main>
  </>;
}
