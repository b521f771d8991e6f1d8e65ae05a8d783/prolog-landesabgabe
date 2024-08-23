% BEGIN DIGITAL ACT

file_search_path(stdlib, './stdlib').
:- use_module(stdlib(stdlib)).

langtitel(labgg, X) :-
    string_concat("Landesgesetz über eine Landesabgabe für das obertägige",
    "Gewinnen mineralischer Rohstoffe (Oö. Landschaftsabgabegesetz)", X).

titel(labgg, "Oö. Landschaftsabgabegesetz").

kurztitel(labgg, "LAbgG").

% §1 Gegenstand der Abgabe:

%% 1. Das Land erhebt eine Landschaftsabgabe für das obertägige Gewinnen mineralischer Rohstoffe in Oberoesterreich. 

abgabe_auf(labgg,
    landesabgabe,
    oberoesterreich,
    bergbau(gewinnen, obertags, mineralische_rohstoffe)).

%% 2. Von der Erhebung ausgenommen sind:
%%% - Abraummaterial,

ausnahme(labgg, X) :-
    current_predicate(abraummaterial/1),
    abraummaterial(X).

%%% - Material aus Fließgewässern, das aus flussbaulichen Gründen wieder in Fließgewässer eingebracht wird,

ausnahme(labgg, X) :-
    current_predicate(entstammt_fliessgewaesser/1),
    entstammt_fliessgewaesser(X).

%%% - bundeseigene mineralische Rohstoffe gemäß § 4 Abs. 1 Mineralrohstoffgesetz (MinroG), BGBl. I Nr. 38/1999, in der Fassung des Bundesgesetzes BGBl. I Nr. 95/2016,  

ausnahme(labgg, X) :-
%# bundeseigener_rohstoff defined in mineralrohstoffgesetz.pl
    bundeseigener_rohstoff(X).

%%% - Kohle,

ausnahme(labgg, kohle).

%%% - Material aus Seitenentnahmen und

ausnahme(labgg, X) :-
    current_predicate(entstammt_seitentnahme/1),
    entstammt_seitentnahme(X).

%%% - Rohstoffe,  deren  Verwendung  Maßnahmen  zur  Abwehr  einer  unmittelbaren  Gefahr  für  das Leben  oder  die  Gesundheit  von  Menschen  oder  zur  unmittelbaren  Abwehr  von  Katastrophen dient.

ausnahme(labgg, X) :-
    current_predicate(rohstoff_zur_abwehr_von_gefahren/1),
    rohstoff_zur_abwehr_von_gefahren(X).

:- discontiguous ausnahme/2.

%% 3. Die Gemeinde, in der sich eine Gewinnungsstätte befindet, erhält einen Ertragsanteil in Höhe von 10 % der Landschaftsabgabe, die im Gemeindegebiet erhoben wurde
%% 4. Der  Ertragsanteil  der  Gemeinde  gemäß  Abs. 3  entfällt  zur  Gänze,  wenn  sich  die  bzw.  der Abgabepflichtige  auf  Grund  von  zivilrechtlichen  Verträgen  verpflichtet  hat,  der  Gemeinde  gegenüber Leistungen zum Ausgleich der Nachteile aus den nach diesem Landesgesetz abgabenpflichtigen Tätigkeiten  zu  erbringen  und  diese  Leistungen  dem  Ertragsanteil  entsprechen  oder  diesen  übersteigen. Wenn  eine  derartige  zivilrechtliche  Leistungsverpflichtung  die  Höhe  des  Ertragsanteils  gemäß  Abs. 3 nicht erreicht, verringert sich der Ertragsanteil um die Höhe der vereinbarten zivilrechtlichen Leistung.

ertragsanteil(labgg
    , gemeinde
    , \+ zivilrechtliche_leistungen
    , 0.1).

ertragsanteil(labgg
    , land
    , \+ zivilrechtliche_leistungen
    , 0.9).

ertragsanteil(labgg
    , gemeinde
    , zivilrechtliche_leistungen
    , 0.0).

ertragsanteil(labgg
    , land
    , zivilrechtliche_leistungen
    , 0.9).

% §2 Begriffsbestimmungen:
%% Im Sinn des Landesgesetzes ist:
%%% 1. „Abraummaterial“:  jedes  beim  Gewinnen  anfallende,  nicht  verwertbare  Material  (zB  taubes Gestein,  Abschlämmbares)  sowie  Materialien,  die  zur  Böschungsherstellung,  Rekultivierung oder Geländegestaltung (zB Lärmschutz- oder Hochwasserschutzdämme) betriebsintern verwendet werden;

abbraummaterial(X) :-
    \+ verwertbar(X) ;
    verwendet_fuer(boschungsherstellung, X) ;
    verwendet_fuer(rekultivierung, X);
    verwendet_fuer(gelaendegestaltung, X).

%%% 2. „Betreiberin“  bzw.  „Betreiber“:  jede  physische  und  juristische  Person  sowie  jeder  sonstige Rechtsträger, die bzw. der ein Gewinnen gewerblich oder berufsmaessig durchführt;

betreiber(X) :-
    (natuerliche_person(X);juristische_person(X);sonstiger_rechtstraeger(X)),
    (gewerblich(X);berufsmaessig(X)).

%%% 3. „Gewinnen“:  das  Lösen  oder  Freisetzen  (Abbau)  mineralischer  Rohstoffe  einschließlich  der durch dieselbe Betreiberin bzw. denselben Betreiber vorgenommenen damit zusammenhängenden vorbereitenden, begleitenden und nachfolgenden Tätigkeiten zur Aufbereitung des Naturmaterials;

gewinnen.

%%% 4. „Gewinnungsstätte“: Steinbruch bzw. Entnahmestelle von mineralischen Rohstoffen unabhängig davon, ob dafür eine Bewilligungspflicht nach dem MinroG besteht;

gewinnungsstaette.

%%% 5. „Mineralischer Rohstoff“: jedes Mineral, Mineralgemenge oder Gestein (Fest- und Lockergestein), wenn es natürlicher Herkunft ist;
%# s.o.

%%% 6. „Seitenentnahme“: obertägiges Gewinnen im direkten Areal eines Bauprojekts zwecks Verwendung bei diesem Bauprojekt;
%# s.o. 

%%% 7. „Verwertung“:  Übergabe  an  Dritte  oder  betriebsinterne  Übergabe  zur  Weiterverarbeitung  nach der Aufbereitung. 
verwertung.

% §3 Abgabepflichtige bzw. Abgabepflichtiger
%% Abgabepflichtige bzw. Abgabepflichtiger ist die Betreiberin bzw. der Betreiber einer Gewinnungsstätte eines abgabepflichtigen Materials

abgabepfichtiger(labgg, X)
    :- betreiber(X).

% §4 Abgabenbefreiung:
%% Von  der  Landschaftsabgabe befreit sind  Betreiberinnen  bzw.  Betreiber,  deren  Abgabenschuld  im jeweiligen Kalenderjahr weniger als 120 Euro beträgt.

ausnahme(labgg,
    preis(X, eur)) :-
    X < 120.

% §5 Höhe der Abgabe:
%% (1)  Die  Höhe  der  Landschaftsabgabe  beträgt  15,95  Cent  pro  Tonne  gewonnenen  und  verwerteten  mineralischen Rohstoffs.

abgabe_hoehe(labgg, X, tonne, 15.95, eur_2017) :- %# eur_2017 ... this means that the levy is 15.94 in 2017's EUR
    (current_predicate(gewonnen/1), gewonnen(X));
    (current_predicate(verwertet/1), verwertet(X)).

%% (2) Der im Abs. 1 festgesetzte Tarif ändert sich jeweils zum 1. Jänner entsprechend den durchschnittlichen Änderungen des von der Bundesanstalt „Statistik Austria“ für das zweitvorangegangene Jahr verlautbarten Verbraucherpreisindex 2015 oder eines an seine Stelle tretenden Index, soweit sich die Indexzahl um mehr als 5 % geändert hat. Bezugsgröße für die erstmalige Änderung ist  der  durchschnittliche  Indexwert  für  das  Jahr  2017;  Bezugsgröße  für  jede  weitere  Änderung  ist  der durchschnittliche Indexwert desjenigen Kalenderjahres, das für die letzte Änderung maßgeblich war. Ein sich  aus  dieser  Berechnung  ergebender  neuer  Betrag  ist  auf  einen  vollen  Zehntel-Centbetrag  zu  runden, wobei Beträge  bis einschließlich 0,05 Cent abgerundet und Beträge  über 0,05 Cent aufgerundet  werden. Eine  solchermaßen  ermittelte  Änderung  des  Tarifs  wird  nur  dann  wirksam,  wenn  der  geänderte  Betrag von der Landesregierung vor dem Stichtag 1. Jänner im Landesgesetzblatt für Oberoesterreich kundgemacht wurde. 

abgabe_hoehe_index(labgg,
    statistik_austria_vpi).

abgabe_hoehe_index_angapassen_wenn(labgg,
    aenderung,
    groesser,
    5,
    percent).

abgabe_hoehe_runden(labgg,
    symmetrisch_IEEE_754_ohne_regel_3).

% §6 Entstehen der Abgabeschuld:
%% Die Abgabenschuld entsteht zu dem Zeitpunkt, in dem das gewonnene Material verwertet wird.

abgabeschuld(labgg,
    verwertung_gewonnenes_material).

% §7 Aufzeichnungspflicht:
%% Die bzw. der Abgabepflichtige ist verpflichtet, zur Feststellung der Abgabe und der Grundlagen ihrer Berechnung Aufzeichnungen zu führen. 

aufzeichnungspflicht(labgg, X) :-
    abgabepfichtiger(X).

% §8 Anzeigepflicht:
%% Die  bzw.  der  Abgabepflichtige  hat  den  Beginn  und  das  Ende  eines  abgabepflichtigen  Gewinnens binnen vier Wochen der Abgabenbehörde anzuzeigen.
%% HINT: try anzeigepflicht(labgg, X).

anzeigepflicht(labgg, X) :-
    abgabepfichtiger(labgg, X).

% §9 Selbstbemessung, Fälligkeit:
%% (1)  Die  bzw.  der  Abgabepflichtige  hat  die  Abgabe  selbst  zu  bemessen.  Die Abgabenerklärung ist  jeweils  bis  30. April  eines  jeden  Jahres  (Fälligkeitstag)  für  die  im  Vorjahr  entstandene  Abgabenschuld einzureichen.

zur_abgabenbemessung_verpflichtet(labgg, X) :-
    abgabepflichtiger(labgg, X).

abgabenerklaerung_einzureichen_bis(labgg,
    allgemein,
    0430).

abgabenerklaerung_einzureichen_bis(labgg,
    erstes_halbjahr_2018,
    1031).

%% (2)  Die  Abgabenerklärung  ist  nach  Gemeinden  und  nach  Gewinnungsstätten  aufzugliedern  und  hat gegebenenfalls auch Angaben über zivilrechtliche Verträge im Sinn des § 1 Abs. 4 zu machen, die einen entsprechend niedrigeren Abgabenbetrag rechtfertigen. Die bzw. der Abgabepflichtige hat den Abgabenbetrag zu berechnen und die Abgabe am Fälligkeitstag zu entrichten.

abgabenerklaerung_aufbau(labgg,
    gewinnungsstaette,
    zivilrechtliche_leistungen).

abgabenschuld_zu_entrichten_bis(labgg,
    allgemein,
    0430).

abgabenschuld_zu_entrichten_bis(labgg,
    erstes_halbjahr_2018,
    1031).

% §10 Behörde:
%% Abgabenbehörde ist die Landesregierung.
abgabenbehoerde(labgg, landesregierung_ooe).

% §11 Schlussbestimmungen:
%% (1) Dieses Landesgesetz tritt mit dem seiner Kundmachung im Landesgesetzblatt für Oberoesterreich folgenden Monatsersten in Kraft.
inkrafttreten(labgg, 20180101).

%% (2) Personen, die zum Zeitpunkt des Inkrafttretens dieses Landesgesetzes bereits eine Gewinnungsstätte eines abgabepflichtigen Materials betreiben, haben ihre  Tätigkeit binnen vier Wochen nach Inkrafttreten dieses Landesgesetzes der Abgabenbehörde anzuzeigen.


%% (3)  Abweichend  von  § 9  ist  die  Abgabenerklärung  für  das  erste  Halbjahr  2018  bis  längstens 31. Oktober 2018 einzureichen und auch die Abgabe für das erste Halbjahr 2018 bis längstens 31. Oktober 2018 zu entrichten.
%# s.o.