:- module(mineralrohstoffgesetz, [bundeseigener_rohstoff/1]).

% § 4. (1)Bundeseigene mineralische Rohstoffe sind:
%   1. Steinsalz und alle anderen mit diesem vorkommenden Salze;
%   2. Kohlenwasserstoffe;
%   3. uran- und thoriumhaltige mineralische Rohstoffe.
% (2) Das Eigentumsrecht an Grund und Boden erstreckt sich nicht auf bundeseigene mineralische Rohstoffe und die Hohlräume der Kohlenwasserstoffträger.

bundeseigener_rohstoff(X) :-
    X = steinsalz;
    X = mit_steinsalz_vorkommende_salze;
    X = kohlenwasserstoffe;
    X = uran_und_thoriumhaltige_rohstoffe.