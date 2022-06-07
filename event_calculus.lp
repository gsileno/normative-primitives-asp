%%% event calculus axioms %%%%%%
holds(F, T) :- holds(F, 0), not clipped(0, F, T), fluent(F), time(T).
holds(F, T2) :- does(X, A, T1), initiates(X, A, F, T1), T1 < T2, not clipped(T1, F, T2), fluent(F), time(T1), time(T2).
clipped(T1, F, T2) :- does(X, A, T), T1 <= T, T < T2, terminates(X, A, F, T), time(T1), time(T2).

%%% integrity rules %%%%%%%%%%%%
% :- initiates(X, A, F, T), holds(F, T).
% :- terminates(X, A, F, T), not holds(F, T), fluent(T), time(T).
% :- does(X, A, T), does(X, neg(A), T).

%%% exploration rules %%%%%%%%%%
% if some agent can perform an action, this may be performed
{does(X, A, T)} :- initiates(X, A, F, T), action(A).
{does(X, A, T)} :- terminates(X, A, F, T), action(A).

% domains
fluent(F) :- holds(F, T).
fluent(F) :- initiates(X, A, F, T).
fluent(F) :- terminates(X, A, F, T).

% interleaved semantics: only one action per time step
:- does(X1, A1, T), does(X2, A2, T), X1 != X2, A1 != A2, action(A1), action(A2).

% reactive execution: inaction is never followed by action (equiv. inaction is a terminal action)
some_action_occurs(T) :- does(_, A, T).
:- not some_action_occurs(T), some_action_occurs(T+1), time(T).