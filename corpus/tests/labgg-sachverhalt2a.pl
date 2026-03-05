% Beispiel-Input für dieses Sachverhalts-Mapping
% "Max Mustermann" fördert in einem obertägigen Bergbau mineralische Rohstoffe.
% Er fördert derzeit zwanzig Tonne Gestein.

subjekt(sachverhalt, max_mustermann).
vorname(max_mustermann, "Max").
nachname(max_mustermann, "Mustermann").

verbum(sachverhalt, max_mustermann, bergbau(gewinnen, obertags, mineralische_rohstoffe)).
objekt(sachverhalt, max_mustermann, bergbau(gewinnen, obertags, mineralische_rohstoffe), mein_gestein).
gefoerdert(mein_gestein, 20, tonne).

% Ausführen mit: abgabepflichtig(labgg, sachverhalt, max_mustermann). --> false
%# (max_mustermann ist kein betreiber: weder natuerliche_person noch gewerblich/berufsmaessig definiert)
% Besteht eine Ausnahme: ausnahme(labgg, max_mustermann, bergbau(gewinnen, obertags, mineralische_rohstoffe), mein_gestein). --> true
%# (20 * 0.2074 = 4.148 Euro < 120 Euro --> Abgabenbefreiung gem. §4)