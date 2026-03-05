# Prolog-Landesabgabe

Maschinelle Subsumtion österreichischer Abgabengesetze mittels logischer Programmierung.

## Motivation und Zielsetzung

In der juristischen Praxis erfordert die Prüfung, ob ein konkreter Sachverhalt unter eine gesetzliche Norm fällt (sog. *Subsumtion*), die systematische Anwendung gesetzlicher Tatbestandsmerkmale auf einen gegebenen Lebenssachverhalt. Dieser Vorgang lässt sich formal als logischer Schluss modellieren.

Das vorliegende Projekt enthält händisch erstellte Formalisierungen österreichischer Gesetzestexte in der Logik-Programmiersprache [Prolog](https://de.wikipedia.org/wiki/Prolog_(Programmiersprache)). Ein Sachverhalt wird als Menge von Fakten formuliert, die Gesetzesnorm als Menge von Regeln -- und das Prolog-System leitet automatisch ab, ob der Tatbestand erfüllt ist oder nicht.

## Kodifizierte Normen

### Oö. Landschaftsabgabegesetz (LAbgG)

Das [LAbgG](https://www.ris.bka.gv.at/GeltendeFassung.wxe?Abfrage=LrOO&Gesetzesnummer=20000943) ist das zentrale und am vollständigsten formalisierte Gesetz im Korpus. Es regelt die Erhebung einer Landesabgabe auf das obertägige Gewinnen mineralischer Rohstoffe in Oberösterreich und ist seit 1. Jänner 2018 in Kraft. Im Folgenden wird die Formalisierung jedes Paragraphen dargestellt.

#### § 1 -- Gegenstand der Abgabe

Abs. 1 normiert den Abgabetatbestand: Das Land Oberösterreich erhebt eine Landschaftsabgabe für das obertägige Gewinnen mineralischer Rohstoffe. Dies wird als vierstelliges Prädikat modelliert, das Gesetz, Abgabenart, Gebietskörperschaft und Handlung verknüpft:

```prolog
abgabe_auf(labgg, landesabgabe, oberoesterreich,
    bergbau(gewinnen, obertags, mineralische_rohstoffe)).
```

Abs. 2 definiert sechs Ausnahmetatbestände. Jeder wird als eigene `ausnahme/4`-Klausel abgebildet, wobei `current_predicate/1`-Guards sicherstellen, dass fehlende Sachverhaltsinformationen nicht zu Laufzeitfehlern führen:

**1. Abraummaterial** -- jedes beim Gewinnen anfallende, nicht verwertbare Material (z.B. taubes Gestein) sowie Material für Böschungsherstellung, Rekultivierung oder Geländegestaltung. Die Ausnahme greift, wenn das Förderobjekt im Sachverhalt als Abraummaterial deklariert ist:

```prolog
ausnahme(labgg, Person, Verbum, Objekt) :-
    abraummaterial(Objekt).
```

**2. Material aus Fließgewässern** -- Material, das aus flussbaulichen Gründen wieder in Fließgewässer eingebracht wird:

```prolog
ausnahme(labgg, Person, Verbum, Objekt) :-
    entstammt_fliessgewaesser(Objekt).
```

**3. Bundeseigene mineralische Rohstoffe** gem. § 4 Abs. 1 MinroG. Diese Ausnahme verweist auf das Modul `mineralrohstoffgesetz`, das die bundeseigenen Rohstoffe enumerativ aufzählt. Die Prüfung erfolgt zweistufig: Zunächst wird die Gesteinsart des Förderobjekts ermittelt, dann gegen die Liste der bundeseigenen Rohstoffe abgeglichen:

```prolog
ausnahme(labgg, Person, Verbum, Objekt) :-
    gestein_art(Objekt, B),
    bundeseigener_rohstoff(B).
```

**4. Kohle** -- eine eigenständige Ausnahme unabhängig vom MinroG. Wenn die Gesteinsart des Förderobjekts als `kohle` bestimmt ist, entfällt die Abgabepflicht:

```prolog
ausnahme(labgg, Person, Verbum, Objekt) :-
    gestein_art(Objekt, kohle).
```

**5. Material aus Seitenentnahmen** -- obertägiges Gewinnen im direkten Areal eines Bauprojekts zwecks Verwendung bei diesem Bauprojekt (vgl. § 2 Z 6):

```prolog
ausnahme(labgg, Person, Verbum, Objekt) :-
    entstammt_seitenentnahme(Objekt).
```

**6. Rohstoffe zur Gefahrenabwehr** -- Rohstoffe, deren Verwendung Maßnahmen zur Abwehr einer unmittelbaren Gefahr für Leben oder Gesundheit von Menschen oder zur unmittelbaren Abwehr von Katastrophen dient:

```prolog
ausnahme(labgg, Person, Verbum, Objekt) :-
    rohstoff_zur_abwehr_von_gefahren(Objekt).
```

Abs. 3--6 regeln die Ertragsanteile (Gemeinde: 20 %, Land: 80 %) sowie die Zweckbindung der Mittel (Natur- und Landschaftsschutz, ökologische Infrastruktur, Umweltbildung). Die Ertragsanteile sind als Fakten modelliert:

```prolog
ertragsanteil(labgg, gemeinde, 0.2).
ertragsanteil(labgg, land, 0.8).
```

#### § 2 -- Begriffsbestimmungen

Die sieben Legaldefinitionen des § 2 (Abraummaterial, Betreiber, Gewinnen, Gewinnungsstätte, Mineralischer Rohstoff, Seitenentnahme, Verwertung) sind teils als Prolog-Regeln formalisiert, teils nur als Kommentar dokumentiert. Vollständig als Regel umgesetzt ist insbesondere der **Betreiber-Begriff** (§ 2 Z 2): Eine Person ist Betreiber, wenn sie eine natürliche oder juristische Person bzw. ein sonstiger Rechtsträger ist *und* das Gewinnen gewerblich oder berufsmäßig durchführt:

```prolog
betreiber(Person) :-
    ((natuerliche_person(Person); juristische_person(Person); sonstiger_rechtstraeger(Person))),
    ((gewerblich(Person); berufsmaessig(Person))).
```

Die Definition von *Abraummaterial* (§ 2 Z 1) ist bewusst nicht als Regel implementiert, da die relevanten Sachverhaltsmerkmale (Verwertbarkeit, betriebsinterne Verwendung) besser direkt im Sachverhalt als Faktum abgebildet werden.

#### § 3 -- Abgabepflichtiger

Abgabepflichtig ist, wer Betreiber einer Gewinnungsstätte abgabepflichtigen Materials ist. Dies wird direkt auf den Betreiber-Begriff aus § 2 zurückgeführt:

```prolog
abgabepflichtiger(labgg, Person) :- betreiber(Person).
```

#### § 4 -- Abgabenbefreiung

Betreiber, deren Abgabenschuld im Kalenderjahr weniger als 120 Euro beträgt, sind befreit. Diese Bagatellgrenze ist als Ausnahme modelliert, die auf die Berechnung aus § 5 zurückgreift:

```prolog
ausnahme(labgg, Person, Verbum, Objekt) :-
    abgabe_hoehe(labgg, Objekt, A),
    A < 120.
```

#### § 5 -- Höhe der Abgabe

Abs. 1 legt den Abgabensatz auf 20,14 Cent pro Tonne fest:

```prolog
abgabe_hoehe(labgg, Objekt, X) :-
    gefoerdert(Objekt, B, tonne),
    X is B * 20.14.
```

Abs. 2 regelt die Indexanpassung anhand des Verbraucherpreisindex der Statistik Austria. Diese Regelung ist als deklarative Fakten (Indexbezug, Änderungsschwelle, Rundungsregel) abgebildet, die dynamische Berechnung ist jedoch noch nicht implementiert:

```prolog
abgabe_hoehe_index(labgg, statistik_austria_vpi).
abgabe_hoehe_index_anpassen_wenn(labgg, aenderung, groesser, 5, percent).
abgabe_hoehe_runden(labgg, symmetrisch_IEEE_754_ohne_regel_3).
```

#### § 6 -- Entstehen der Abgabeschuld

Die Abgabenschuld entsteht im Zeitpunkt der Verwertung des gewonnenen Materials:

```prolog
abgabenschuld_zeitpunkt(labgg, Objekt, X) :-
    verwertet_am(Objekt, X).
```

#### §§ 7--8 -- Aufzeichnungs- und Anzeigepflicht

Beide Pflichten knüpfen an die Abgabepflicht an und sind identisch strukturiert:

```prolog
aufzeichnungspflicht(labgg, X) :- abgabepflichtiger(labgg, X).
anzeigepflicht(labgg, X) :- abgabepflichtiger(labgg, X).
```

#### § 9 -- Selbstbemessung und Fälligkeit

Der Abgabepflichtige hat die Abgabe selbst zu bemessen. Die Fälligkeitstermine sind als Fakten modelliert, einschließlich der abweichenden Übergangsregelung für das erste Halbjahr 2018:

```prolog
abgabenerklaerung_einzureichen_bis(labgg, allgemein, 0430).
abgabenerklaerung_einzureichen_bis(labgg, erstes_halbjahr_2018, 1031).
```

#### § 10 -- Behörde

```prolog
abgabenbehoerde(labgg, landesregierung_ooe).
```

#### § 11 -- Schlussbestimmungen

```prolog
inkrafttreten(labgg, 20180101).
```

#### Subsumtionsprüfung

Die zentrale Hilfsfunktion `abgabepflichtig/3` führt die vollständige Subsumtion durch: Sie prüft, ob eine Person Subjekt eines Sachverhalts ist, ob die Handlung unter den Abgabetatbestand fällt und ob *keine* Ausnahme greift:

```prolog
abgabepflichtig(labgg, Sachverhalt, Person) :-
    subjekt(Sachverhalt, Person),
    verbum(Sachverhalt, Person, Verbum),
    objekt(Sachverhalt, Person, Verbum, Objekt),
    abgabe_auf(labgg, landesabgabe, oberoesterreich, Verbum),
    \+ ausnahme(labgg, Person, Verbum, Objekt).
```

### Mineralrohstoffgesetz (MinroG) -- § 4

Das Modul `mineralrohstoffgesetz` bildet § 4 Abs. 1 MinroG ab, der die bundeseigenen mineralischen Rohstoffe enumerativ aufzählt: Steinsalz (und mit diesem vorkommende Salze), Kohlenwasserstoffe sowie uran- und thoriumhaltige Rohstoffe. Dieses Modul wird vom LAbgG referenziert, um den Ausnahmetatbestand für bundeseigene Rohstoffe zu prüfen.

## Standardbibliothek (`corpus/stdlib/`)

Neben den oben genannten Normen enthält die Standardbibliothek allgemeine, normübergreifende Wissensbasen:

| Modul | Inhalt |
|---|---|
| `abgabe` | Klassifikation der Abgabenarten (Stadt-, Landes-, Bundes-, EU-Abgabe) |
| `bergbau` | Gewinnungsarten (obertags, untertags) und Rohstoffarten |
| `gebietskoerperschaften` | EU-Mitgliedstaaten, österreichische Bundesländer, sämtliche Bezirke und Gemeinden Oberösterreichs |

## Sachverhaltsmodellierung

Ein konkreter Lebenssachverhalt wird als Menge von Prolog-Fakten modelliert. Hierfür wird ein einheitliches Schema verwendet:

- **Subjekt**: `subjekt(Sachverhalt, Person)` -- ordnet eine Person einem Sachverhalt zu
- **Personeneigenschaften**: `natuerliche_person/1`, `juristische_person/1`, `gewerblich/1`, `berufsmaessig/1`
- **Handlung**: `verbum(Sachverhalt, Person, Handlung)` -- beschreibt, was die Person tut
- **Objekt**: `objekt(Sachverhalt, Person, Handlung, Gegenstand)` -- der Gegenstand der Handlung
- **Quantifizierung**: `gefoerdert(Gegenstand, Menge, Einheit)`, `verwertet_am(Gegenstand, Datum)`

Beispiel: *"Max Mustermann betreibt berufsmäßig obertägigen Bergbau und fördert 2 Tonnen mineralische Rohstoffe"*:

```prolog
subjekt(sachverhalt, max_mustermann).
natuerliche_person(max_mustermann).
berufsmaessig(max_mustermann).
verbum(sachverhalt, max_mustermann, bergbau(gewinnen, obertags, mineralische_rohstoffe)).
objekt(sachverhalt, max_mustermann, bergbau(gewinnen, obertags, mineralische_rohstoffe), mein_gestein).
gefoerdert(mein_gestein, 2, tonne).
```

Die Subsumtionsprüfung `abgabepflichtig(labgg, sachverhalt, max_mustermann)` liefert in diesem Fall `false`, da die Abgabe von 40,28 Cent unter der Freigrenze von 120 Euro liegt (§ 4 LAbgG).

## Testfälle (`corpus/tests/`)

Das Projekt enthält mehrere Beispiel-Sachverhalte, die die korrekte Anwendung der formalisierten Normen demonstrieren:

- **Sachverhalt 1** (Kohleförderung): Der geförderte Rohstoff ist Kohle. Die Ausnahme gem. § 1 Abs. 2 LAbgG greift. Ergebnis: Keine Abgabepflicht.
- **Sachverhalt 3** (Geringe Fördermenge): Bei 2 Tonnen beträgt die Abgabe 40,28 Cent -- unterhalb der Freigrenze von 120 Euro gem. § 4 LAbgG. Ergebnis: Abgabenbefreiung.

## Technische Umsetzung

Das System ist als reine Frontend-Anwendung konzipiert -- es wird kein Backend benötigt. Der Prolog-Korpus (`corpus/`) wird zur Build-Zeit direkt in das JavaScript-Bundle eingebettet. Die Prolog-Abfragen werden vollständig im Browser ausgeführt, wahlweise über [SWI-Prolog](https://www.swi-prolog.org/) (via `swipl-wasm`) oder [Scryer Prolog](https://github.com/mthom/scryer-prolog) (via WebAssembly, erfordert Rust + `wasm-pack`). Die Benutzeroberfläche ist ein React/TypeScript-Frontend (`src/`) mit Mantine-UI und Sachverhalts-Editor. Als Build-System dient Nix Flakes (`nix build .#frontend`), für die lokale Entwicklung genügt `npm install && npm run dev`. Das Deployment auf Cloudflare Workers erfolgt via `npx wrangler deploy`.

## TODO

- KI-gestützte automatische Übersetzung von Gesetzestexten aus dem [RIS](https://www.ris.bka.gv.at/) in Scryer-Prolog
- Implementierung der dynamischen Indexanpassung gem. § 5 Abs. 2 LAbgG
- Formalisierung weiterer österreichischer Normen

## Rechtshinweis

Die in diesem Projekt enthaltenen Prolog-Regeln stellen eine händisch erstellte, formale Abbildung gesetzlicher Normen dar und ersetzen keine Rechtsberatung. Bei der Übersetzung natürlichsprachlicher Normtexte in formale Regeln können Ungenauigkeiten auftreten. Für rechtsverbindliche Auskünfte ist eine juristische Fachperson heranzuziehen.
