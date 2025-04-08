% Beispiel-Input für dieses Sachverhalts-Mapping
% "Max Mustermann"(53) betreibt Bergbau und gewinnt dabei obertags den mineralischen Rohstoffe "Kohle".

subjekt(sachverhalt, max_mustermnann).
vorname(max_mustermann, "Max").
nachname(max_mustermann, "Mustermann").
alter(max_mustermann, 53).

verbum(sachverhalt, bergbau(gewinnen, obertags, mineralische_rohstoffe)).
objekt(sachverhalt, mein_gestein).

gestein_art(mein_gestein, kohle).

% Ausführen mit: abgabepflichtig(labgg, sachverhalt, max_mustermann). --> false
% Besteht eine Ausnahme: ausnahme(labgg, max_mustermann, bergbau(gewinnen, obertags, mineralische_rohstoffe), mein_gestein). --> true