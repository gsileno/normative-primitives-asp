%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ASP encoding of normative relationships <g.sileno@uva.nl> %
% atemporal characterization                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% to be run eg. on https://potassco.org/clingo/run/



%%%%%%% normative relationships definitions

%%%% relationships on first hohfeldian square

noclaim(X, Y, A) :- -claim(X, Y, A). 
  claim(X, Y, A) :- -noclaim(X, Y, A). 
-claim(X, Y, A) :- noclaim(X, Y, A). 
  -noclaim(X, Y, A) :- claim(X, Y, A). 

duty(Y, X, A) :- claim(X, Y, A).
  -claim(X, Y, A) :- -duty(Y, X, A).
claim(X, Y, A) :- duty(Y, X, A).
  -duty(Y, X, A) :- -claim(X, Y, A).

liberty(Y, X, A) :- -claim(X, Y, neg(A)), action(A).
  claim(X, Y, neg(A)) :- -liberty(Y, X, A), action(A).
-claim(X, Y, neg(A)) :- liberty(Y, X, A), action(A).
  -liberty(Y, X, A) :- claim(X, Y, neg(A)), action(A). 

liberty(Y, X, neg(A)) :- -claim(X, Y, A), action(A).
  claim(X, Y, A) :- -liberty(Y, X, neg(A)), action(A).
-claim(X, Y, A) :- liberty(Y, X, neg(A)), action(A).
  -liberty(Y, X, neg(A)) :- claim(X, Y, A), action(A).

%%%% relationships on second hohfeldian square

disability(X, Y, A) :- -power(X, Y, A).
  power(X, Y, A) :- -disability(X, Y, A).
-power(X, Y, A) :- disability(X, Y, A). 
  -disability(X, Y, A) :- power(X, Y, A).

liability(Y, X, A) :- power(X, Y, A).
  -power(X, Y, A) :- -liability(Y, X, A).
power(X, Y, A) :- liability(Y, X, A). 
  -liability(Y, X, A) :- -power(X, Y, A).

immunity(Y, X, A) :- -power(X, Y, A).
  power(X, Y, A) :- -immunity(Y, X, A).
-power(X, Y, A) :- immunity(Y, X, A).
  -immunity(Y, X, A) :- power(X, Y, A).

%%%%%%% aristotelian diagrams centered on claim

% deontic square of opposition

-claim(X, Y, neg(A)) :- claim(X, Y, A).
  -claim(X, Y, A) :- claim(X, Y, neg(A)).

% change-centered potestative square of opposition

power_oreilly(X, Y, B, A) :- ability(X, B, plus(claim(X, Y, A))).
  -ability(X, B, plus(claim(X, Y, A))) :- -power_oreilly(X, Y, B, A).
power_oreilly(X, Y, B, A) :- ability(X, B, plus(claim(X, Y, neg(A)))).
  -ability(X, B, plus(claim(X, Y, neg(A)))) :- -power_oreilly(X, Y, B, A). 
power_oreilly(X, Y, B, A) :- ability(X, B, minus(claim(X, Y, A))).
  -ability(X, B, minus(claim(X, Y, A))) :- -power_oreilly(X, Y, B, A).
power_oreilly(X, Y, B, A) :- ability(X, B, minus(claim(X, Y, neg(A)))).
  -ability(X, B, minus(claim(X, Y, neg(A)))) :- -power_oreilly(X, Y, B, A).

-power_oreilly(X, Y, B, A) :- 
  -ability(X, B, plus(claim(X, Y, A))), 
  -ability(X, B, plus(claim(X, Y, neg(A)))), 
  -ability(X, B, minus(claim(X, Y, A))),
  -ability(X, B, minus(claim(X, Y, neg(A)))).

poschange_power(X, Y, A) :- power_oreilly(X, Y, B, A).
  % -power_oreilly(X, Y, B, A) :- -poschange_power(X, Y, A). % existential rule
  :- power_oreilly(X, Y, B, A), -poschange_power(X, Y, A).   % rephrased as impossibility constraint
poschange_power(X, Y, A) :- -nochange_power(X, Y, A).
  nochange_power(X, Y, A) :- -poschange_power(X, Y, A).

% force-centered power potestative square of opposition

posforce_power(X, Y, A) :- ability(X, require(A), plus(claim(X, Y, A))).
  -ability(X, require(A), plus(claim(X, Y, A))) :- -posforce_power(X, Y, A). 
ability(X, require(A), plus(claim(X, Y, A))) :- posforce_power(X, Y, A).
  -posforce_power(X, Y, A) :- -ability(X, require(A), plus(claim(X, Y, A))).

negforce_power(X, Y, A) :- ability(X, require(A), plus(claim(X, Y, neg(A)))), action(A).
  -ability(X, require(A), plus(claim(X, Y, neg(A)))) :- -negforce_power(X, Y, A), action(A).
ability(X, require(A), plus(claim(X, Y, neg(A)))) :- negforce_power(X, Y, A), action(A).
  -negforce_power(X, Y, A) :- -ability(X, require(A), plus(claim(X, Y, neg(A)))), action(A).
negforce_power(X, Y, neg(A)) :- ability(X, require(neg(A)), plus(claim(X, Y, A))), action(A).
  -ability(X, require(neg(A)), plus(claim(X, Y, A))) :- -negforce_power(X, Y, neg(A)), action(A).
ability(X, require(neg(A)), plus(claim(X, Y, A))) :- negforce_power(X, Y, neg(A)), action(A).
  -negforce_power(X, Y, neg(A)) :- -ability(X, require(neg(A)), plus(claim(X, Y, A))), action(A).

-negforce_power(X, Y, A) :- posforce_power(X, Y, A).
  -posforce_power(X, Y, A) :- negforce_power(X, Y, A).

% outcome-centered power potestative square of opposition

power(X, Y, A) :- ability(X, B, plus(claim(X, Y, A))).
-power(X, Y, A) :- -ability(X, B, plus(claim(X, Y, A))).
  % -ability(X, B, plus(claim(X, Y, A))) :- -power(X, Y, A). % existential rule
  :- ability(X, B, plus(claim(X, Y, A))), -power(X, Y, A).   % rephrased as impossibility constraint
negpower(X, Y, A) :- ability(X, B, minus(claim(X, Y, A))).
-negpower(X, Y, A) :- -ability(X, B, minus(claim(X, Y, A))).
  % -ability(X, B, minus(claim(X, Y, A))) :- -negpower(X, Y, A). % existential rule
  :- ability(X, B, minus(claim(X, Y, A))), -negpower(X, Y, A).    % rephrased as impossibility constraint

-negpower(X, Y, A) :- power(X, Y, A).
  -power(X, Y, A) :- negpower(X, Y, A).

% full-liberties

full_liberty(X, Y, A) :- liberty(X, Y, A), liberty(X, Y, neg(A)), action(A).
full_noclaim(Y, X, A) :- full_liberty(X, Y, A).

-full_liberty(X, Y, A) :- -liberty(X, Y, A).
-full_liberty(X, Y, A) :- -liberty(X, Y, neg(A)).
-full_noclaim(Y, X, A) :- -full_liberty(X, Y, A).

% full_disabilities

full_disability(X, Y, A) :- disability(X, Y, A), disability(X, Y, neg(A)), action(A).
full_immunity(Y, X, A) :- full_disability(X, Y, A).

-full_disability(X, Y, A) :- -disability(X, Y, A).
-full_disability(X, Y, A) :- -disability(X, Y, neg(A)).
-full_immunity(Y, X, A) :- -full_disability(X, Y, A).

%%%%%%% deontic closure rules

% if not prohibited/requested explicitly, you are not prohibited/requested

-claim(X, Y, neg(A)) :- X != Y, not claim(X, Y, neg(A)), agent(X), agent(Y), action(A).
-claim(X, Y, A) :- X != Y, not claim(X, Y, A), agent(X), agent(Y), action(A).

%%%%%%% potestative closure rules

% if not empowered explicitly, you do not have power

-ability(X, require(A), plus(claim(X, Y, A))) :- X != Y, not ability(X, require(A), plus(claim(X, Y, A))), agent(X), agent(Y), action(A). % positive force power (positive duty)
-ability(X, require(neg(A)), plus(claim(X, Y, neg(A)))) :- X != Y, not ability(X, require(neg(A)), plus(claim(X, Y, neg(A)))), agent(X), agent(Y), action(A). % positive force power (positive duty)
%-ability(X, require(A), plus(claim(X, Y, neg(A)))) :- X != Y, not ability(X, require(A), plus(claim(X, Y, neg(A)))), agent(X), agent(Y), action(A). % negative force power (negative duty) % TOCHECK
%-ability(X, require(neg(A)), plus(claim(X, Y, A))) :- X != Y, not ability(X, require(neg(A)), plus(claim(X, Y, A))), agent(X), agent(Y), action(A). % negative force power (negative duty) % TOCHECK

