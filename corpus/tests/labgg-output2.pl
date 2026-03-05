% Sachverhalt
:- discontiguous verbum/3.
:- discontiguous nachname/2.
:- discontiguous vorname/2.
:- discontiguous natuerliche_person/1.
:- discontiguous alter/2.
:- discontiguous subjekt/2.
:- discontiguous objekt/4.

% Person
subjekt(sachverhalt_b5be3b5bec004fbeba753c3d4de7766e, person_a0eb262448e44aeb9973a4ea33648ab4).
vorname(person_a0eb262448e44aeb9973a4ea33648ab4, "Alexander").
nachname(person_a0eb262448e44aeb9973a4ea33648ab4, "Hipfl").
natuerliche_person(person_a0eb262448e44aeb9973a4ea33648ab4).
alter(person_a0eb262448e44aeb9973a4ea33648ab4, 24).


% Handlung
verbum(sachverhalt_b5be3b5bec004fbeba753c3d4de7766e, person_a0eb262448e44aeb9973a4ea33648ab4, bergbau(gewinnen, obertags, mineralische_rohstoffe)).
objekt(sachverhalt_b5be3b5bec004fbeba753c3d4de7766e, person_a0eb262448e44aeb9973a4ea33648ab4, bergbau(gewinnen, obertags, mineralische_rohstoffe), gestein_9de3832e8d6d4b62a829e7c212498c39).
gefoerdert(gestein_9de3832e8d6d4b62a829e7c212498c39, 50, tonne).
verwertet_am(gestein_9de3832e8d6d4b62a829e7c212498c39, date(2025, 3, 1, 0, 0, 0, Off, TZ, DST)).
