% Beispiel-Input für dieses Sachverhalts-Mapping
% "Max Mustermann" fördert in einem obertägigen Bergbau mineralische Rohstoffe.

subjekt(sachverhalt, max_mustermann).
vorname(max_mustermann, "Max").
nachname(max_mustermann, "Mustermann").

verbum(sachverhalt, bergbau(gewinnen, obertags, mineralische_rohstoffe)).
objekt(sachverhalt, mein_gestein).

% Ausführen mit: abgabepflichtig_labbg(sachverhalt).