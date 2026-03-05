# Oö. Landschaftsabgabegesetz - Änderungshistorie

Gesetzesnummer: 20000943
RIS: https://www.ris.bka.gv.at/GeltendeFassung.wxe?Abfrage=LrOO&Gesetzesnummer=20000943

## Stammfassung

| LGBl | Datum | Beschreibung |
|------|-------|-------------|
| LGBl.Nr. 99/2017 | 28.12.2017 | Stammfassung (GP XXVIII IA 567/2017). Inkrafttreten: 01.01.2018. Einführung der Landschaftsabgabe für das obertägige Gewinnen mineralischer Rohstoffe in Oberösterreich. |

## Novellen

| LGBl | Datum | Betroffene Paragraphen | Beschreibung |
|------|-------|----------------------|-------------|
| LGBl.Nr. 95/2022 | 2022 | §5 Abs. 2, §11 (neu), §12 (ehem. §11) | Neufassung §5 Abs. 2 (Indexanpassungsregel, Basiszinssatz 15,95 Cent). Neuer §11: Übermittlung von Daten (Betreiberdaten, Gewinnungsmengen an zuständige Stellen für Rohstoffinformationssystem). Bisheriger §11 (Schlussbestimmungen) wird zu §12. |
| LGBl.Nr. 96/2023 | 27.07.2023 | §1 Abs. 3-6, §9 Abs. 2, §11 Abs. 3 | Erhöhung des Ertragsanteils der Gemeinde von 10% auf 20%. Neufassung der Verwendungszwecke (Abs. 4, 5). Überweisung an Gemeinden bis 30. Juni (Abs. 6). Neufassung §9 Abs. 2: Streichung des Verweises auf "zivilrechtliche Verträge im Sinn des § 1 Abs. 4"; Aufgliederung nur noch nach Gemeinden und Gewinnungsstätten. Ergänzung §11 Abs. 3 (Hinweispflicht der Naturschutzbehörde). |

## Indexanpassungen (Kundmachungen)

| K LGBl | Wirksamkeit ab | Tarif (Cent/Tonne) | Beschreibung |
|--------|---------------|-------------------|-------------|
| K LGBl.Nr. 75/2024 | 01.01.2025 | 20,14 | Erste Indexanpassung gemäß §5 Abs. 2 auf Basis VPI 2015 |
| K LGBl.Nr. 36/2025 | 01.01.2026 | 20,74 | Indexanpassung: "Die Höhe der Landschaftsabgabe beträgt ab dem 1. Jänner 2026 20,74 Cent pro Tonne" |

## Geltende Fassung (Stand: März 2026)

### Paragraphenübersicht

| Paragraph | Titel | Letzte Änderung |
|-----------|-------|----------------|
| §1 | Gegenstand der Abgabe | LGBl.Nr. 96/2023 |
| §2 | Begriffsbestimmungen | Stammfassung |
| §3 | Abgabepflichtige/r | Stammfassung |
| §4 | Abgabenbefreiung (< 120 EUR) | Stammfassung |
| §5 | Höhe der Abgabe (Basis: 15,95 Cent; aktuell: 20,74 Cent) | LGBl.Nr. 95/2022 |
| §6 | Entstehen der Abgabenschuld | Stammfassung |
| §7 | Aufzeichnungspflicht | Stammfassung |
| §8 | Anzeigepflicht | Stammfassung |
| §9 | Selbstbemessung, Fälligkeit | LGBl.Nr. 96/2023 |
| §10 | Behörde | Stammfassung |
| §11 | Übermittlung von Daten | LGBl.Nr. 95/2022, 96/2023 |
| §12 | Schlussbestimmungen | LGBl.Nr. 95/2022 |

### Hinweise zur Prolog-Implementierung

- Die Prolog-Datei `corpus/labgg.pl` referenziert §11 als Schlussbestimmungen. In der aktuellen Fassung ist dies §12 (§11 wurde durch LGBl.Nr. 95/2022 für "Übermittlung von Daten" eingefügt).
- Der Tarif in der Prolog-Datei verwendet den aktuellen indexangepassten Wert von 20,74 Cent/Tonne (= 0,2074 EUR/Tonne), nicht den gesetzlichen Basiszinssatz von 15,95 Cent.
- `abgabe_hoehe/3` berechnet in Euro (nicht Cent), damit die Abgabenbefreiung in §4 (< 120 Euro) direkt vergleichbar ist.
