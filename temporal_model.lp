%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ASP encoding of normative relationships <g.sileno@uva.nl> %
% temporal characterization via Event Calculus              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% to be run eg. on https://potassco.org/clingo/run/

%%%%%%% normative relationships definitions

%%%% relationships on first hohfeldian square

holds(noclaim(X, Y, A), T) :- -holds(claim(X, Y, A), T). 
  holds(claim(X, Y, A), T) :- -holds(noclaim(X, Y, A), T). 
-holds(claim(X, Y, A), T) :- holds(noclaim(X, Y, A), T). 
  -holds(noclaim(X, Y, A), T) :- holds(claim(X, Y, A), T). 

holds(duty(Y, X, A), T) :- holds(claim(X, Y, A), T).
  -holds(claim(X, Y, A), T) :- -holds(duty(Y, X, A), T).
claim(X, Y, A) :- holds(duty(Y, X, A), T).
  -holds(duty(Y, X, A), T) :- -holds(claim(X, Y, A), T).

holds(liberty(Y, X, A), T) :- -holds(claim(X, Y, neg(A)), T), action(A).
  holds(claim(X, Y, neg(A)), T) :- -holds(liberty(Y, X, A), T), action(A).
-holds(claim(X, Y, neg(A)), T) :- holds(liberty(Y, X, A), T), action(A).
  -holds(liberty(Y, X, A), T) :- holds(claim(X, Y, neg(A)), T), action(A). 

holds(liberty(Y, X, neg(A)), T) :- -holds(claim(X, Y, A), T), action(A).
  holds(claim(X, Y, A), T) :- -holds(liberty(Y, X, neg(A)), T), action(A).
-holds(claim(X, Y, A), T) :- holds(liberty(Y, X, neg(A)), T), action(A).
  -holds(liberty(Y, X, neg(A)), T) :- holds(claim(X, Y, A), T), action(A).

%%%% relationships on second hohfeldian square

holds(disability(X, Y, A), T) :- -holds(power(X, Y, A), T).
  holds(power(X, Y, A), T) :- -holds(disability(X, Y, A), T).
-holds(power(X, Y, A), T) :- holds(disability(X, Y, A), T). 
  -holds(disability(X, Y, A), T) :- holds(power(X, Y, A), T).

holds(liability(Y, X, A), T) :- holds(power(X, Y, A), T).
  -holds(power(X, Y, A), T) :- -holds(liability(Y, X, A), T).
holds(power(X, Y, A), T) :- holds(liability(Y, X, A), T). 
  -holds(liability(Y, X, A), T) :- -holds(power(X, Y, A), T).

holds(immunity(Y, X, A), T) :- -holds(power(X, Y, A), T).
  holds(power(X, Y, A), T) :- -holds(immunity(Y, X, A), T).
-holds(power(X, Y, A), T) :- holds(immunity(Y, X, A), T).
  -holds(immunity(Y, X, A), T) :- holds(power(X, Y, A), T).

%%%%%%% aristotelian diagrams centered on claim

% deontic square of opposition

-holds(claim(X, Y, neg(A)), T) :- holds(claim(X, Y, A), T).
  -holds(claim(X, Y, A), T) :- holds(claim(X, Y, neg(A)), T).

% change-centered potestative square of opposition

holds(power_oreilly(X, Y, B, A), T) :- holds(ability(X, B, plus(claim(X, Y, A))), T).
  -holds(ability(X, B, plus(claim(X, Y, A))), T) :- -holds(power_oreilly(X, Y, B, A), T).
holds(power_oreilly(X, Y, B, A), T) :- holds(ability(X, B, plus(claim(X, Y, neg(A)))), T).
  -holds(ability(X, B, plus(claim(X, Y, neg(A)))), T) :- -holds(power_oreilly(X, Y, B, A), T). 
holds(power_oreilly(X, Y, B, A), T) :- holds(ability(X, B, minus(claim(X, Y, A))), T).
  -holds(ability(X, B, minus(claim(X, Y, A))), T) :- -holds(power_oreilly(X, Y, B, A), T).
holds(power_oreilly(X, Y, B, A), T) :- holds(ability(X, B, minus(claim(X, Y, neg(A)))), T).
  -holds(ability(X, B, minus(claim(X, Y, neg(A)))), T) :- -holds(power_oreilly(X, Y, B, A), T).

-holds(power_oreilly(X, Y, B, A), T) :- 
  -holds(ability(X, B, plus(claim(X, Y, A))), T), 
  -holds(ability(X, B, plus(claim(X, Y, neg(A)))), T), 
  -holds(ability(X, B, minus(claim(X, Y, A))), T),
  -holds(ability(X, B, minus(claim(X, Y, neg(A)))), T).

holds(poschange_power(X, Y, A), T) :- holds(power_oreilly(X, Y, B, A), T).
  % -holds(power_oreilly(X, Y, B, A), T) :- -holds(poschange_power(X, Y, A), T). % existential rule
  :- holds(power_oreilly(X, Y, B, A), T), -holds(poschange_power(X, Y, A), T).   % rephrased as impossibility constraint
holds(poschange_power(X, Y, A), T) :- -holds(nochange_power(X, Y, A), T).
  holds(nochange_power(X, Y, A), T) :- -holds(poschange_power(X, Y, A), T).

% force-centered power potestative square of opposition

holds(posforce_power(X, Y, A), T) :- holds(ability(X, request(A), plus(claim(X, Y, A))), T).
  -holds(ability(X, request(A), plus(claim(X, Y, A))), T) :- -holds(posforce_power(X, Y, A), T). 
holds(ability(X, request(A), plus(claim(X, Y, A))), T) :- holds(posforce_power(X, Y, A), T).
  -holds(posforce_power(X, Y, A), T) :- -holds(ability(X, request(A), plus(claim(X, Y, A))), T).

holds(negforce_power(X, Y, A), T) :- holds(ability(X, request(A), plus(claim(X, Y, neg(A)))), T).
  -holds(ability(X, request(A), plus(claim(X, Y, neg(A)))), T) :- -holds(negforce_power(X, Y, A), T).
holds(ability(X, request(A), plus(claim(X, Y, neg(A)))), T) :- holds(negforce_power(X, Y, A), T).
  -holds(negforce_power(X, Y, A), T) :- -holds(ability(X, request(A), plus(claim(X, Y, neg(A)))), T).

-holds(negforce_power(X, Y, A), T) :- holds(posforce_power(X, Y, A), T).
  -holds(posforce_power(X, Y, A), T) :- holds(negforce_power(X, Y, A), T).

% outcome-centered power potestative square of opposition

holds(power(X, Y, A), T) :- holds(ability(X, B, plus(claim(X, Y, A))), T).
  % -holds(ability(X, B, plus(claim(X, Y, A))), T) :- -holds(power(X, Y, A), T). % existential rule
  :- holds(ability(X, B, plus(claim(X, Y, A))), T), -holds(power(X, Y, A), T).   % rephrased as impossibility constraint
holds(negpower(X, Y, A), T) :- holds(ability(X, B, minus(claim(X, Y, A))), T).
  % -holds(ability(X, B, minus(claim(X, Y, A))), T) :- -holds(negpower(X, Y, A), T). % existential rule
  :- holds(ability(X, B, minus(claim(X, Y, A))), T), -holds(negpower(X, Y, A), T).    % rephrased as impossibility constraint

-holds(negpower(X, Y, A), T) :- holds(power(X, Y, A), T).
  -holds(power(X, Y, A), T) :- holds(negpower(X, Y, A), T).

% full-liberties

holds(full_liberty(X, Y, A), T) :- holds(liberty(X, Y, A), T), holds(liberty(X, Y, neg(A)), T), action(A).
holds(full_noclaim(Y, X, A), T) :- holds(full_liberty(X, Y, A), T).

% full_disabilities

holds(full_disability(X, Y, A), T) :- holds(disability(X, Y, A), T), holds(disability(X, Y, neg(A)), T), action(A).
holds(full_immunity(Y, X, A), T) :- holds(full_disability(X, Y, A), T).

%%%%%%% deontic closure rules

% % if not prohibited/requested explicitly, you are not prohibited/requested

% -holds(claim(X, Y, neg(A)), T) :- X != Y, not holds(claim(X, Y, neg(A)), T), agent(X), agent(Y), action(A), time(T).
% -holds(claim(X, Y, A), T) :- X != Y, not holds(claim(X, Y, A), T), agent(X), agent(Y), action(A), time(T).

% %%%%%%% potestative closure rules

% % if not empowered explicitly, you do not have power

% -holds(power(X, Y, A), T) :- X != Y, not holds(power(X, Y, A), T), agent(X), agent(Y), action(A), time(T).
% -holds(power(X, Y, neg(A)), T) :- X != Y, not holds(power(X, Y, neg(A)), T), agent(X), agent(Y), action(A), time(T).
% -holds(negpower(X, Y, A), T) :- X != Y, not holds(negpower(X, Y, A), T), agent(X), agent(Y), action(A), time(T).
% -holds(negpower(X, Y, neg(A)), T) :- X != Y, not holds(negpower(X, Y, neg(A)), T), agent(X), agent(Y), action(A), time(T).
