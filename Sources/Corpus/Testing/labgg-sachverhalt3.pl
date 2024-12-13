% Beispiel-Input für dieses Sachverhalts-Mapping
% "Max Mustermann" ist Betreiber und fördert in einem obertägigen Bergbau mineralische Rohstoffe. Er fördert dieses Jahr 1 Tonne mineralische Rohstoffe. Heinricht R. ist eine
% natürliche Person und 30 Jahre alt.

:- discontiguous vorname/2.
:- discontiguous nachname/2.
:- discontiguous natuerliche_person/1.
:- discontiguous subjekt/2.
:- debug.

subjekt(sachverhalt, max_mustermann).
vorname(max_mustermann, "Max").
nachname(max_mustermann, "Mustermann").
natuerliche_person(max_mustermann).
berufsmaessig(max_mustermann).

verbum(sachverhalt, max_mustermann, bergbau(gewinnen, obertags, mineralische_rohstoffe)).
objekt(sachverhalt, max_mustermann, bergbau(gewinnen, obertags, mineralische_rohstoffe), mein_gestein).
gefoerdert(mein_gestein, 2, tonne).
verwertet_am(mein_gestein, date(2024, 11, 12, 0, 0, 0, Off, TZ, DST)).

subjekt(sachverhalt, heinrich_raudinger).
vorname(reinrich_raudinger, "Heinrich").
nachname(heinrich_raudinger, "Raudinger").
natuerliche_person(heinrich_raudinger).
alter(heinrich_raudinger, 30).

% abgabe_hoehe(labgg, mein_gestein, Y).
% abgabepfichtiger(labgg, X). --> max_mustermann 
% abgabenschuld_zeitpunkt(labgg, mein_gestein, X).
% aufzeichnungspflicht(labgg, X). -> max_mustermann
% ausnahme(labgg, max_mustermann, bergbau(gewinnen, obertags, mineralische_rohstoffe), mein_gestein). --> true, weil Menge zu klein
% abgabepflichtig(labgg, sachverhalt, max_mustermann). --> false
% abgabepflichtig(labgg, sachverhalt, heinrich_raudinger). --> false