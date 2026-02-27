:- module(abgabe, [abgaben_art/1]).

abgaben_art(X) :-
    X = stadt_abgabe ;
    X = landesabgabe ;
    X = bundesabgabe ;
    X = eu_abgabe .