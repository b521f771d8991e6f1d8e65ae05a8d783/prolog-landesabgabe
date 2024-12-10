% Beispiel-Input für dieses Sachverhalts-Mapping
% "Max Mustermann"(53) betreibt Bergbau und gewinnt dabei obertags den mineralischen Rohstoffe "Kohle".

subjekt(sachverhalt, max_mustermnann).
vorname(max_mustermann, "Max").
nachname(max_mustermann, "Mustermann").
alter(max_mustermann, 53).

verbum(sachverhalt, bergbau(gewinnen, obertags, mineralische_rohstoffe)).
objekt(sachverhalt, mein_gestein).

kohle(mein_gestein).

% Ausführen mit: abgabepflichtig_labbg(sachverhalt).