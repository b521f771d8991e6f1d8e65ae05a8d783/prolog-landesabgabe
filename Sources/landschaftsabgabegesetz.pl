% Langtitel: Landesgesetz über eine Landesabgabe für das obertägige Gewinnen mineralischer Rohstoffe (Oö. Landschaftsabgabegesetz)
% Titel: Oö. Landschaftsabgabegesetz
% Kurztitel: LAbgG

file_search_path(stdLib, './StdLib').

:- use_module(stdLib(abgabe)).
:- use_module(stdLib(bergbau)).
:- use_module(stdLib(gebietskoerperschaften)).
:- use_module(stdLib(mineralrohstoffgesetz)).

% §1 Gegenstand der Abgabe:

%   1. Das Land erhebt eine Landschaftsabgabe für das obertägige Gewinnen mineralischer Rohstoffe in Oberoesterreich. 
abgabe_auf(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe, landesabgabe, oberoesterreich, bergbau(gewinnen, obertags, mineralische_rohstoffe)).

% andere Abgaben (für Demozecke)
abgabe_auf(hundehalterabgabe, gemeinde, X, zivilrecht_eigentuemer(hund)) :-
    gemeinde(oesterreich, X).
abgabe_auf(humusabgabe, gemeinde, tragwein, zivilrecht_eigentuemer(humus)).
abgabe_auf(grunderwerbssteuer, bundesabgabe, oesterreich, X) :-
    (zivilrecht_erwerb_entgeltlich(X) ; zivilrecht_erwerb_unentgeltlich(X)),
    grund_und_boden(X).

%   2. Von der Erhebung ausgenommen sind:
%       - Abraummaterial,
%       - Material aus Fließgewässern, das aus flussbaulichen Gründen wieder in Fließgewässer eingebracht wird,
%       - bundeseigene mineralische Rohstoffe gemäß § 4 Abs. 1 Mineralrohstoffgesetz (MinroG), BGBl. I Nr. 38/1999, in der Fassung des Bundesgesetzes BGBl. I Nr. 95/2016,  
%       - Kohle,
%       - Material aus Seitenentnahmen und
%       - Rohstoffe,  deren  Verwendung  Maßnahmen  zur  Abwehr  einer  unmittelbaren  Gefahr  für  das Leben  oder  die  Gesundheit  von  Menschen  oder  zur  unmittelbaren  Abwehr  von  Katastrophen dient.

ausnahme(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe, X) :-
    current_predicate(abraummaterial/1),
    abraummaterial(X).

ausnahme(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe, X) :-
    current_predicate(entstammt_fliessgewaesser/1),
    entstammt_fliessgewaesser(X).

ausnahme(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe, X) :-
    % bundeseigener_rohstoff defined in mineralrohstoffgesetz.pl
    bundeseigener_rohstoff(X).

ausnahme(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe, kohle).

ausnahme(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe, X) :-
    current_predicate(ist_seitentnahme/1),
    ist_seitentnahme(X).

ausnahme(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe, X) :-
    current_predicate(rohstoff_zur_abwehr_von_gefahren/1),
    rohstoff_zur_abwehr_von_gefahren(X).

ausnahme(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe, preis(X, eur)) :-
    X < 120.

%   3. Die Gemeinde, in der sich eine Gewinnungsstätte befindet, erhält einen Ertragsanteil in Höhe von 10 % der Landschaftsabgabe, die im Gemeindegebiet erhoben wurde
%   4. Der  Ertragsanteil  der  Gemeinde  gemäß  Abs. 3  entfällt  zur  Gänze,  wenn  sich  die  bzw.  der Abgabepflichtige  auf  Grund  von  zivilrechtlichen  Verträgen  verpflichtet  hat,  der  Gemeinde  gegenüber Leistungen zum Ausgleich der Nachteile aus den nach diesem Landesgesetz abgabenpflichtigen Tätigkeiten  zu  erbringen  und  diese  Leistungen  dem  Ertragsanteil  entsprechen  oder  diesen  übersteigen. Wenn  eine  derartige  zivilrechtliche  Leistungsverpflichtung  die  Höhe  des  Ertragsanteils  gemäß  Abs. 3 nicht erreicht, verringert sich der Ertragsanteil um die Höhe der vereinbarten zivilrechtlichen Leistung.
ertragsanteil(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe
    , gemeinde
    , \+ zivilrechtliche_leistungen
    , 0.1).
ertragsanteil(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe
    , land
    , \+ zivilrechtliche_leistungen
    , 0.9).
ertragsanteil(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe
    , gemeinde
    , zivilrechtliche_leistungen
    , 0.0).
ertragsanteil(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe
    , land
    , zivilrechtliche_leistungen
    , 0.9).

% §2 Begriffsbestimmungen:
% Im Sinn des Landesgesetzes ist:
%   1. „Abraummaterial“:  jedes  beim  Gewinnen  anfallende,  nicht  verwertbare  Material  (zB  taubes Gestein,  Abschlämmbares)  sowie  Materialien,  die  zur  Böschungsherstellung,  Rekultivierung oder Geländegestaltung (zB Lärmschutz- oder Hochwasserschutzdämme) betriebsintern verwendet werden;
abbraummaterial(X) :-
    \+ verwertbar(X) ;
    verwendet_fuer(boschungsherstellung, X) ;
    verwendet_fuer(rekultivierung, X);
    verwendet_fuer(gelaendegestaltung, X).

%   2. „Betreiberin“  bzw.  „Betreiber“:  jede  physische  und  juristische  Person  sowie  jeder  sonstige Rechtsträger, die bzw. der ein Gewinnen gewerblich oder berufsmaessig durchführt;
betreiber(X) :-
    (natuerliche_person(X);juristische_person(X);sonstiger_rechtstraeger(X)),
    (gewerblich(X);berufsmaessig(X)).

%   3. „Gewinnen“:  das  Lösen  oder  Freisetzen  (Abbau)  mineralischer  Rohstoffe  einschließlich  der durch dieselbe Betreiberin bzw. denselben Betreiber vorgenommenen damit zusammenhängenden vorbereitenden, begleitenden und nachfolgenden Tätigkeiten zur Aufbereitung des Naturmaterials;
gewinnen.

%   4. „Gewinnungsstätte“: Steinbruch bzw. Entnahmestelle von mineralischen Rohstoffen unabhängig davon, ob dafür eine Bewilligungspflicht nach dem MinroG besteht;
gewinnungsstaette.

%   5. „Mineralischer Rohstoff“: jedes Mineral, Mineralgemenge oder Gestein (Fest- und Lockergestein), wenn es natürlicher Herkunft ist;
mineralischer_rohstoff.

%   6. „Seitenentnahme“: obertägiges Gewinnen im direkten Areal eines Bauprojekts zwecks Verwendung bei diesem Bauprojekt;
seitenentnahmen.

%   7. „Verwertung“:  Übergabe  an  Dritte  oder  betriebsinterne  Übergabe  zur  Weiterverarbeitung  nach der Aufbereitung. 
verwertung.

% §3 Abgabepflichtige bzw. Abgabepflichtiger
% Abgabepflichtige bzw. Abgabepflichtiger ist die Betreiberin bzw. der Betreiber einer Gewinnungsstätte eines abgabepflichtigen Materials
abgabepfichtiger(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe, betreiber_gewinnungsstaette).

abgabepflichtiger(bundesteuer_ust, juristische_person_unternehmer_lt_P2UStG). % example of a reference
abgabepflichtiger(bundessteuer_koest, juristische_personen_koerperschaften_lt_P1KStG).

% §4 Abgabenbefreiung:
% Von  der  Landschaftsabgabe befreit sind  Betreiberinnen  bzw.  Betreiber,  deren  Abgabenschuld  im jeweiligen Kalenderjahr weniger als 120 Euro beträgt.
% s.o.

% §5 Höhe der Abgabe:
%   (1)  Die  Höhe  der  Landschaftsabgabe  beträgt  15,95  Cent  pro  Tonne  gewonnenen  und  verwerteten  mineralischen Rohstoffs.
abgabe_hoehe(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe, tonne_gewonnener_u_verwerteter_rohstoff_in_kg, 15.95, eur_2017). % eur_2017 ... this means that the levy is 15.94 in 2017's EUR
abgabe_hoehe(grundstuecke, m2, 12, dollar).

%   (2) Der im Abs. 1 festgesetzte Tarif ändert sich jeweils zum 1. Jänner entsprechend den durchschnittlichen Änderungen des von der Bundesanstalt „Statistik Austria“ für das zweitvorangegangene Jahr verlautbarten Verbraucherpreisindex 2015 oder eines an seine Stelle tretenden Index, soweit sich die Indexzahl um mehr als 5 % geändert hat. Bezugsgröße für die erstmalige Änderung ist  der  durchschnittliche  Indexwert  für  das  Jahr  2017;  Bezugsgröße  für  jede  weitere  Änderung  ist  der durchschnittliche Indexwert desjenigen Kalenderjahres, das für die letzte Änderung maßgeblich war. Ein sich  aus  dieser  Berechnung  ergebender  neuer  Betrag  ist  auf  einen  vollen  Zehntel-Centbetrag  zu  runden, wobei Beträge  bis einschließlich 0,05 Cent abgerundet und Beträge  über 0,05 Cent aufgerundet  werden. Eine  solchermaßen  ermittelte  Änderung  des  Tarifs  wird  nur  dann  wirksam,  wenn  der  geänderte  Betrag von der Landesregierung vor dem Stichtag 1. Jänner im Landesgesetzblatt für Oberoesterreich kundgemacht wurde. 
abgabe_hoehe_index(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe, statistik_austria_vpi).
abgabe_hoehe_index_angapassen_wenn(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe, aenderung, groesser, 5, percent).
abgabe_hoehe_runden(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe, symmetrisch_IEEE_754_ohne_regel_3).

% §6 Entstehen der Abgabeschuld:
% Die Abgabenschuld entsteht zu dem Zeitpunkt, in dem das gewonnene Material verwertet wird.
abgabeschuld(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe, verwertung_gewonnenes_material).

% §7 Aufzeichnungspflicht:
% Die bzw. der Abgabepflichtige ist verpflichtet, zur Feststellung der Abgabe und der Grundlagen ihrer Berechnung Aufzeichnungen zu führen. 
aufzeichnungspflicht(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe).

% §8 Anzeigepflicht:
% Die  bzw.  der  Abgabepflichtige  hat  den  Beginn  und  das  Ende  eines  abgabepflichtigen  Gewinnens binnen vier Wochen der Abgabenbehörde anzuzeigen.
% HINT: try anzeigepflicht(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe, X).
anzeigepflicht(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe, X) :-
    abgabepfichtiger(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe, X).

% §9 Selbstbemessung, Fälligkeit:
%   (1)  Die  bzw.  der  Abgabepflichtige  hat  die  Abgabe  selbst  zu  bemessen.  Die Abgabenerklärung ist  jeweils  bis  30. April  eines  jeden  Jahres  (Fälligkeitstag)  für  die  im  Vorjahr  entstandene  Abgabenschuld einzureichen.
zur_abgabenbemessung_verepflichtet(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe, X) :-
    abgabepflichtiger(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe, X).
abgabenerklaerung_einzureichen_bis(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe, allgemein, 0430).
abgabenerklaerung_einzureichen_bis(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe, erstes_halbjahr_2018, 1031).

%   (2)  Die  Abgabenerklärung  ist  nach  Gemeinden  und  nach  Gewinnungsstätten  aufzugliedern  und  hat gegebenenfalls auch Angaben über zivilrechtliche Verträge im Sinn des § 1 Abs. 4 zu machen, die einen entsprechend niedrigeren Abgabenbetrag rechtfertigen. Die bzw. der Abgabepflichtige hat den Abgabenbetrag zu berechnen und die Abgabe am Fälligkeitstag zu entrichten.
abgabenerklaerung_aufbau(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe, gewinnungsstaette, zivilrechtliche_leistungen).
abgabenschuld_zu_entrichten_bis(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe, allgemein, 0430).
abgabenschuld_zu_entrichten_bis(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe, erstes_halbjahr_2018, 1031).

% §10 Behörde:
% Abgabenbehörde ist die Landesregierung.
abgabenbehoerde(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe, landesregierung_ooe).

% §11 Schlussbestimmungen:
%   (1) Dieses Landesgesetz tritt mit dem seiner Kundmachung im Landesgesetzblatt für Oberoesterreich folgenden Monatsersten in Kraft.
inkrafttreten(landesabgabe_ooe_obertaetige_gewinnen_von_mineralische_rohstoffe, 20180101).

%   (2) Personen, die zum Zeitpunkt des Inkrafttretens dieses Landesgesetzes bereits eine Gewinnungsstätte eines abgabepflichtigen Materials betreiben, haben ihre  Tätigkeit binnen vier Wochen nach Inkrafttreten dieses Landesgesetzes der Abgabenbehörde anzuzeigen.


%   (3)  Abweichend  von  § 9  ist  die  Abgabenerklärung  für  das  erste  Halbjahr  2018  bis  längstens 31. Oktober 2018 einzureichen und auch die Abgabe für das erste Halbjahr 2018 bis längstens 31. Oktober 2018 zu entrichten.
% -> s.o.