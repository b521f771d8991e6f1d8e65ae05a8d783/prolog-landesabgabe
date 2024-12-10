% Beispiel-Input für dieses Sachverhalts-Mapping
% "Max Mustermann" ist Betreiber und fördert in einem obertägigen Bergbau mineralische Rohstoffe.

subjekt(sachverhalt, max_mustermann).

vorname(max_mustermann, "Max").
nachname(max_mustermann, "Mustermann").
natuerliche_person(max_mustermann).
berufsmaessig(max_mustermann).

vorname(reinrich_raudinger, "Heinrich").
nachname(reinrich_raudinger, "Raudinger").
natuerliche_person(reinrich_raudinger).
alter(reinrich_raudinger, 30).

verbum(sachverhalt, bergbau(gewinnen, obertags, mineralische_rohstoffe)).
objekt(sachverhalt, mein_gestein).
gefoerdert(mein_gestein, 1, tonne).

% Wer ist Betreiber? betreiber(X)
% abgabe_hoehe(labgg, sachverhalt, Y).
% abgabepflichtig(labbg, la)