
% Filename: /src/static/labgg.pl
% file_search_path(stdlib, './stdlib').
%:- use_module(stdlib(stdlib)).

:- if(current_prolog_flag(dialect, swi)).
:- style_check(-singleton).
:- endif.

langtitel(labgg,
    "Landesgesetz über eine Landesabgabe für das obertägige Gewinnen mineralischer Rohstoffe (Oö. Landschaftsabgabegesetz)").
titel(labgg, "Oö. Landschaftsabgabegesetz").
kurztitel(labgg, "LAbgG").

% §1 Gegenstand der Abgabe:

%% 1. Das Land erhebt eine Landschaftsabgabe für das obertägige Gewinnen mineralischer Rohstoffe in Oberösterreich.

:- discontiguous abgabe_auf/4.
:- discontiguous ausnahme/4.

abgabe_auf(labgg,
    landesabgabe,
    oberoesterreich,
    bergbau(gewinnen, obertags, mineralische_rohstoffe)).

%% 2. Von der Erhebung ausgenommen sind:
%%% - Abraummaterial,

ausnahme(labgg, Person, Verbum, Objekt) :-
    current_predicate(abraummaterial/1),
    abraummaterial(Objekt).

%%% - Material aus Fließgewässern, das aus flussbaulichen Gründen wieder in Fließgewässer eingebracht wird,

ausnahme(labgg, Person, Verbum, Objekt) :-
    current_predicate(entstammt_fliessgewaesser/1),
    entstammt_fliessgewaesser(Objekt).

%%% - bundeseigene mineralische Rohstoffe gemäß § 4 Abs. 1 Mineralrohstoffgesetz (MinroG), BGBl. I Nr. 38/1999, in der Fassung des Bundesgesetzes BGBl. I Nr. 95/2016,  

ausnahme(labgg, Person, Verbum, Objekt) :-
%# bundeseigener_rohstoff defined in mineralrohstoffgesetz.pl
    current_predicate(gestein_art/2),
    gestein_art(Objekt, B),
    current_predicate(bundeseigener_rohstoff/1),
    bundeseigener_rohstoff(B).

%%% - Kohle,

ausnahme(labgg, Person, Verbum, Objekt) :-
    current_predicate(gestein_art/2),
    gestein_art(Objekt, kohle).

%%% - Material aus Seitenentnahmen und

ausnahme(labgg, Person, Verbum, Objekt) :-
    current_predicate(entstammt_seitenentnahme/1),
    entstammt_seitenentnahme(Objekt).

%%% - Rohstoffe,  deren  Verwendung  Maßnahmen  zur  Abwehr  einer  unmittelbaren  Gefahr  für  das Leben  oder  die  Gesundheit  von  Menschen  oder  zur  unmittelbaren  Abwehr  von  Katastrophen dient.

ausnahme(labgg, Person, Verbum, Objekt) :-
    current_predicate(rohstoff_zur_abwehr_von_gefahren/1),
    rohstoff_zur_abwehr_von_gefahren(Objekt).

%% 3. Die Gemeinde, in der sich eine Gewinnungsstätte befindet, erhält einen Ertragsanteil in Höhe von 20 % der Landschaftsabgabe, die im Gemeindegebiet erhoben wurde (Anm: LGBl.Nr. 96/2023)

%% (4) Die Landschaftsabgabe ist für Angelegenheiten des Natur- und Landschaftsschutzes sowie der
%% Landschafts- und Ortsbildpflege, zur Verbesserung der ökologischen Infrastruktur, die Umweltbildung
%% und Umwelterziehung sowie sonstige Maßnahmen im Bereich des Umweltschutzes zu verwenden. (Anm:
%% LGBl.Nr. 96/2023)
%% (5) Die der Gemeinde gemäß Abs. 3 zufließenden Mittel sind für Angelegenheiten des Natur- und
%% Landschaftsschutzes sowie der Landschafts- und Ortsbildpflege, zur Verbesserung der ökologischen
%% Infrastruktur, für naturnahe Erholungsformen in der Gemeinde, die Umweltbildung oder die
%% Umwelterziehung zu verwenden. (Anm: LGBl.Nr. 96/2023)
%% (6) Die Überweisung des Ertragsanteils an die Gemeinden hat jeweils spätestens am 30. Juni für das
%% vorangegangene Kalenderjahr zu erfolgen. (Anm: LGBl.Nr. 96/2023)

ertragsanteil(labgg
    , gemeinde
    , 0.2).

ertragsanteil(labgg
    , land
    , 0.8).

% §2 Begriffsbestimmungen:
%% Im Sinn des Landesgesetzes ist:
%%% 1. „Abraummaterial“: jedes beim Gewinnen anfallende,
%%%    nicht verwertbare Material (zB taubes Gestein, Abschlämmbares) sowie Materialien,
%%%    die zur Böschungsherstellung, Rekultivierung oder Geländegestaltung
%%%    (zB Lärmschutz- oder Hochwasserschutzdämme) betriebsintern verwendet werden;

%#  it actually makes more sense to omit these.
%#abbraummaterial(X) :-
%#    \+ verwertbar(X) ;
%#    verwendet_fuer(boschungsherstellung, X) ;
%#    verwendet_fuer(rekultivierung, X) ;
%#    verwendet_fuer(gelaendegestaltung, X).

%%% 2. „Betreiberin“  bzw.  „Betreiber“:  jede  physische  und  juristische  Person  sowie  jeder  sonstige Rechtsträger, die bzw. der ein Gewinnen gewerblich oder berufsmaessig durchführt;

betreiber(Person) :-
    ((current_predicate(natuerliche_person/1), natuerliche_person(Person));
     (current_predicate(juristische_person/1), juristische_person(Person));
     (current_predicate(sonstiger_rechtstraeger/1), sonstiger_rechtstraeger(Person))),
    ((current_predicate(gewerblich/1), gewerblich(Person));
     (current_predicate(berufsmaessig/1), berufsmaessig(Person))
    ).

%%% 3. „Gewinnen“:  das  Lösen  oder  Freisetzen  (Abbau)  mineralischer  Rohstoffe  einschließlich  der durch dieselbe Betreiberin bzw. denselben Betreiber vorgenommenen damit zusammenhängenden vorbereitenden, begleitenden und nachfolgenden Tätigkeiten zur Aufbereitung des Naturmaterials;
%%% 4. „Gewinnungsstätte“: Steinbruch bzw. Entnahmestelle von mineralischen Rohstoffen unabhängig davon, ob dafür eine Bewilligungspflicht nach dem MinroG besteht;
%%% 5. „Mineralischer Rohstoff“: jedes Mineral, Mineralgemenge oder Gestein (Fest- und Lockergestein), wenn es natürlicher Herkunft ist;
%%% 6. „Seitenentnahme“: obertägiges Gewinnen im direkten Areal eines Bauprojekts zwecks Verwendung bei diesem Bauprojekt;
%%% 7. „Verwertung“:  Übergabe  an  Dritte  oder  betriebsinterne  Übergabe  zur  Weiterverarbeitung  nach der Aufbereitung. 

% §3 Abgabepflichtige bzw. Abgabepflichtiger
%% Abgabepflichtige bzw. Abgabepflichtiger ist die Betreiberin bzw. der Betreiber einer Gewinnungsstätte eines abgabepflichtigen Materials

abgabepflichtiger(labgg, Person)
    :- betreiber(Person).

% §4 Abgabenbefreiung:
%% Von  der  Landschaftsabgabe befreit sind  Betreiberinnen  bzw.  Betreiber,  deren  Abgabenschuld  im jeweiligen Kalenderjahr weniger als 120 Euro beträgt.

ausnahme(labgg, Person, Verbum, Objekt) :-
    abgabe_hoehe(labgg, Objekt, A),
    A < 120. 

% §5 Höhe der Abgabe:
%% (1)  Die  Höhe  der  Landschaftsabgabe  beträgt  15,95  Cent  pro  Tonne  gewonnenen  und
%%      verwerteten  mineralischen Rohstoffs. (Anm: LGBl.Nr. 95/2022)
%%      Indexangepasster Tarif: 20,74 Cent pro Tonne (K LGBl.Nr. 36/2025, ab 1. Jänner 2026)

abgabe_hoehe(labgg, Objekt, X) :-
    current_predicate(gefoerdert/3),
    gefoerdert(Objekt, B, tonne),
    X is B * 0.2074.

%% (2) Der im Abs. 1 festgesetzte Tarif ändert sich jeweils zum 1. Jänner entsprechend den durchschnittlichen Änderungen des von der Bundesanstalt „Statistik Austria“ für das zweitvorangegangene Jahr verlautbarten Verbraucherpreisindex 2015 oder eines an seine Stelle tretenden Index, soweit sich die Indexzahl um mehr als 5 % geändert hat. Bezugsgröße für die erstmalige Änderung ist  der  durchschnittliche  Indexwert  für  das  Jahr  2017;  Bezugsgröße  für  jede  weitere  Änderung  ist  der durchschnittliche Indexwert desjenigen Kalenderjahres, das für die letzte Änderung maßgeblich war. Ein sich  aus  dieser  Berechnung  ergebender  neuer  Betrag  ist  auf  einen  vollen  Zehntel-Centbetrag  zu  runden, wobei Beträge  bis einschließlich 0,05 Cent abgerundet und Beträge  über 0,05 Cent aufgerundet  werden. Eine  solchermaßen  ermittelte  Änderung  des  Tarifs  wird  nur  dann  wirksam,  wenn  der  geänderte  Betrag von der Landesregierung vor dem Stichtag 1. Jänner im Landesgesetzblatt für Oberoesterreich kundgemacht wurde. 

abgabe_hoehe_index(labgg, statistik_austria_vpi).
abgabe_hoehe_index_anpassen_wenn(labgg, aenderung, groesser, 5, percent).
abgabe_hoehe_runden(labgg, symmetrisch_IEEE_754_ohne_regel_3).

% §6 Entstehen der Abgabeschuld:
%% Die Abgabenschuld entsteht zu dem Zeitpunkt, in dem das gewonnene Material verwertet wird.

abgabenschuld_zeitpunkt(labgg, Objekt, X) :-
    current_predicate(verwertet_am/2),
    verwertet_am(Objekt, X).

% §7 Aufzeichnungspflicht:
%% Die bzw. der Abgabepflichtige ist verpflichtet, zur Feststellung der Abgabe und der Grundlagen ihrer Berechnung Aufzeichnungen zu führen. 

aufzeichnungspflicht(labgg, X) :-
    abgabepflichtiger(labgg, X).

% §8 Anzeigepflicht:
%% Die  bzw.  der  Abgabepflichtige  hat  den  Beginn  und  das  Ende  eines  abgabepflichtigen  Gewinnens binnen vier Wochen der Abgabenbehörde anzuzeigen.

anzeigepflicht(labgg, X) :-
    abgabepflichtiger(labgg, X).

% §9 Selbstbemessung, Fälligkeit:
%% (1)  Die  bzw.  der  Abgabepflichtige  hat  die  Abgabe  selbst  zu  bemessen.  Die Abgabenerklärung ist  jeweils  bis  30. April  eines  jeden  Jahres  (Fälligkeitstag)  für  die  im  Vorjahr  entstandene  Abgabenschuld einzureichen.

zur_abgabenbemessung_verpflichtet(labgg, X) :-
    abgabepflichtiger(labgg, X).

abgabenerklaerung_einzureichen_bis(labgg, allgemein, 0430).
abgabenerklaerung_einzureichen_bis(labgg, erstes_halbjahr_2018, 1031).

%% (2)  Die  Abgabenerklärung  ist  nach  Gemeinden  und  nach  Gewinnungsstätten  aufzugliedern.
%%      Die bzw. der Abgabepflichtige hat den Abgabenbetrag zu berechnen und die Abgabe am
%%      Fälligkeitstag zu entrichten. (Anm: LGBl.Nr. 96/2023)

abgabenerklaerung_aufbau(labgg, gemeinde, gewinnungsstaette).
abgabenschuld_zu_entrichten_bis(labgg, allgemein, 0430).
abgabenschuld_zu_entrichten_bis(labgg, erstes_halbjahr_2018, 1031).

% §10 Behörde:
%% Abgabenbehörde ist die Landesregierung.
abgabenbehoerde(labgg, landesregierung_ooe).

% §12 Schlussbestimmungen: (Anm: LGBl.Nr. 95/2022)
%% (1) Dieses Landesgesetz tritt mit dem seiner Kundmachung im Landesgesetzblatt für Oberoesterreich folgenden Monatsersten in Kraft.
inkrafttreten(labgg, 20180101).

%% (2) Personen, die zum Zeitpunkt des Inkrafttretens dieses Landesgesetzes bereits eine Gewinnungsstätte eines abgabepflichtigen Materials betreiben, haben ihre  Tätigkeit binnen vier Wochen nach Inkrafttreten dieses Landesgesetzes der Abgabenbehörde anzuzeigen.

%% (3)  Abweichend  von  § 9  ist  die  Abgabenerklärung  für  das  erste  Halbjahr  2018  bis  längstens 31. Oktober 2018 einzureichen und auch die Abgabe für das erste Halbjahr 2018 bis längstens 31. Oktober 2018 zu entrichten.
%# s.o.

% utility functions
abgabepflichtig(labgg, Sachverhalt, Person) :-
    subjekt(Sachverhalt, Person),
    verbum(Sachverhalt, Person, Verbum),
    objekt(Sachverhalt, Person, Verbum, Objekt),
    abgabe_auf(labgg, landesabgabe, oberoesterreich, Verbum),
    \+ ausnahme(labgg, Person, Verbum, Objekt).
% Filename: input_daae9163_4606_43b7_b9e4_3f978456a54e.pl
% Sachverhalt
                :- discontiguous verbum/3.
                :- discontiguous nachname/2.
                :- discontiguous vorname/2.
                :- discontiguous natuerliche_person/1.
                :- discontiguous alter/2.
                :- discontiguous subjekt/2.
                :- discontiguous objekt/4.
                :- discontiguous verwertet_am/2.
                :- discontiguous gefoerdert/3.
        
            
        % Person
        subjekt(sachverhalt_11ecba201a3445a39eeaec391f6fbd30, person_d6798eaee1644f2ca98b1102344f292e).
        vorname(person_d6798eaee1644f2ca98b1102344f292e, "Test").
        nachname(person_d6798eaee1644f2ca98b1102344f292e, "Test").
        natuerliche_person(person_d6798eaee1644f2ca98b1102344f292e).
        alter(person_d6798eaee1644f2ca98b1102344f292e, 12).
        
        
        
        % Handlung
        verbum(sachverhalt_11ecba201a3445a39eeaec391f6fbd30, person_d6798eaee1644f2ca98b1102344f292e, bergbau(gewinnen, obertags, mineralische_rohstoffe)).
        objekt(sachverhalt_11ecba201a3445a39eeaec391f6fbd30, person_d6798eaee1644f2ca98b1102344f292e, bergbau(gewinnen, obertags, mineralische_rohstoffe), gestein_6b334f830368414184a06d52f07d63c3).
        gefoerdert(gestein_6b334f830368414184a06d52f07d63c3, 7, tonne).
        verwertet_am(gestein_6b334f830368414184a06d52f07d63c3, date(2025, 5, 1, 0, 0, 0, Off, TZ, DST)).
        