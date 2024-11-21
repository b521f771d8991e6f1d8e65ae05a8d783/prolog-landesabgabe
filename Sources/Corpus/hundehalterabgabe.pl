file_search_path(stdlib, './stdlib').
:- use_module(stdlib(stdlib)).

abgabe_auf(hundehalterabgabe, gemeinde, X, zivilrecht_eigentuemer(hund)) :-
    gemeinde(oesterreich, X).