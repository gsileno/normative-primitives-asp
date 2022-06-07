%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ASP encoding of normative relationships <g.sileno@uva.nl> %
% temporal characterization via Event Calculus              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% to be run eg. on https://potassco.org/clingo/run/

%%% exploration axioms
{does(X, A, T)} :- holds(ability(X, A, _), T), action(A).
{does(Y, A, T)} :- holds(claim(_, Y, A), T), action(A).
{does(Y, A, T)} :- holds(claim(_, Y, neg(A)), T), action(A).

%%% mapping from ability to event calculus predicates
initiates(X, A, F, T) :- holds(ability(X, A, plus(F)), T).
terminates(X, A, ability(X, A, plus(F)), T) :- holds(ability(X, A, plus(F)), T).
terminates(X, A, F, T) :- holds(ability(X, A, minus(F)), T).
terminates(X, A, ability(X, A, minus(F)), T) :- holds(ability(X, A, minus(F)), T).

%%% qualification of actions
does(Y, fulfill(claim(X, Y, A)), T) :- does(Y, A, T), holds(claim(X, Y, A), T).
does(Y, violate(claim(X, Y, A)), T) :- does(Y, neg(A), T), holds(claim(X, Y, A), T), action(A).
does(Y, violate(claim(X, Y, neg(A))), T) :- does(Y, A, T), holds(claim(X, Y, neg(A)), T), action(A).

% achievement duties
terminates(Y, fulfill(claim(X, Y, A)), claim(X, Y, A), T) :- holds(claim(X, Y, A), T), action(A).

% violation
initiates(Y, violate(claim(X, Y, A)), violated(claim(X, Y, A)), T) :- holds(claim(X, Y, A), T).

%%% qualify negative actions (in relevant conditions)
does(X, neg(A), T) :- holds(claim(_, X, A), T), not does(X, A, T), agent(X), action(A), time(T).