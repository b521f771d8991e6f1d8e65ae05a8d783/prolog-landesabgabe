abgabe_auf(grunderwerbssteuer, bundesabgabe, oesterreich, X) :-
    (zivilrecht_erwerb_entgeltlich(X) ; zivilrecht_erwerb_unentgeltlich(X)),
    grund_und_boden(X).