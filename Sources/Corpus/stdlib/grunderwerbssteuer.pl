:- module(grunderwerbssteuer, [abgabe_auf/4]).

abgabe_auf(grunderwerbssteuer, bundesabgabe, oesterreich, X) :-
    ((current_predicate(zivilrecht_erwerb_entgeltlich/1), zivilrecht_erwerb_entgeltlich(X)) ;
    (current_predicate(zivilrecht_erwerb_unentgeltlich/1), zivilrecht_erwerb_unentgeltlich(X))),
    current_predicate(grund_und_boden/1), grund_und_boden(X).