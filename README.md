# Normative primitives in ASP

ASP logic programs and Python helpers for normative reasoning. 

## Logic programs

- `atemporal_model.lp` contains axioms for:
  - Hohfeld's framework of primitive concepts
  - normative squares of oppotions (deontic, force power, outcome power, change power)
  - closure norms (defaults: liberty and disability)
  - full liberty and full disability (more aligned to the common-sense meaning of these concepts)
- `event_calculus.lp` contains simple event calculus axioms adjusted for agents performing actions.
- `temporal_model_bridge.lp` contains bridging axioms from normative concepts to event calculus (eg. `ability` to `initiates`)

## Python helpers

- `asp_wrapper.py` runs the `clingo` ASP solver (https://potassco.org/clingo/) and collect answers set in easily reusable data structures. 
- `ec_wrapper.py` runs and visualizes dynamic models based on event calculus.
- `atemporal_model.py` runs and visualizes normative reasoning on static scenarios
- `temporal_model.py` runs and visualizes normative reasoning on dynamic scenarios via event calculus

## Dependencies

you need to install the ASP solver `clingo`, eg. by means of Anaconda:
```
conda install -c potassco clingo
``` 

Predicates expressed in answer sets are parsed via SLY (https://github.com/dabeaz/sly). Download it on your computer.
Update `sys.path.insert(0, '../SLY')` at the beginning of `predicate.py` with your directory.

## Running examples

### Atemporal model

The ASP axiomatization is meant to infer all normative relationships given some normative relationships at a certain instant in time.
The following examples utilize the python helpers in the repository: 

#### example of duty, obligation, ie. deontic concept

Input: _Paul has a duty towards John to pay_.

```
from atemporal_model import atemporal_model, solve, query, unpack

case = """
agent(john). agent(paul). action(pay).
duty(paul, john, pay).
"""

answer_sets = solve(atemporal_model+case)
unpack(query(answer_sets))
```

Output:
```
john towards paul: claim to pay
john towards paul: full_liberty to pay
paul towards john: duty to pay
paul towards john: full_noclaim to pay
john upon paul: full_disability to require pay
john towards paul: full_immunity to be required to pay
paul upon john: full_disability to require pay
paul towards john: full_immunity to be required to pay
```

#### example of power, ie. potestative concept

Input: _John has a power upon Paul concerning paying_ (that is: John can require Paul to pay). 

We use the predicate `ability` as it has the finest granularity of specification.
```
from atemporal_model import atemporal_model, solve, query, unpack

case = """
agent(john). agent(paul). action(pay).
ability(john, require(pay), plus(claim(john, paul, pay)))."""
answer_sets = solve(atemporal_model+case)
unpack(query(answer_sets))

answer_sets = solve(atemporal_model+case)
unpack(query(answer_sets))
```

Output:
```
paul towards john: full_liberty to pay
paul towards john: full_noclaim to pay
john towards paul: full_liberty to pay
john towards paul: full_noclaim to pay
john upon paul: power to require pay
john towards paul: full_immunity to be required to pay
paul towards john: liability to be required to pay
paul upon john: full_disability to require pay
```

### Temporal model

The ASP axiomatization (based on event calculus) is meant to infer the dynamics of normative relationships exploring all potential execution branches (including violations). The following examples utilize the python helpers in the repository: 

#### sale example

Input: _By offering, John gives Paul the power to accept. By accepting, Paul creates upon John the duty to deliver, and upon himself the duty to pay_

Here we explore the space of execution paths for the 3 time steps:
```
from temporal_model import ec_logic, temporal_model, solve, event_query, event_show, configuration_show_function

case = """
agent(john). agent(paul). action(offer). action(accept). action(pay). action(deliver).
holds(ability(john, offer, plus(ability(paul, accept, plus(claim(john, paul, pay))))), 0).
holds(ability(john, offer, plus(ability(paul, accept, plus(claim(paul, john, deliver))))), 0).
time(0..3)."""
answer_sets = solve(ec_logic+temporal_model+case)
actors, actions, fluents, alternative_scenarios = event_query(answer_sets)
event_show(actors, actions, fluents, alternative_scenarios, configuration_show_function, newline=True)
```

Output: 9 scenarios, here excerpts

_John does not offer._
```---- scenario 1 
.. time 0 
.. time 1 
.. time 2 
.. time 3 
```

_John offers, but Paul does not accept_
```---- scenario 9
.. time 0 
=> does(john, offer) 
.. time 1 
paul upon john: power to require deliver
john towards paul: liability to be required to deliver
.. time 2 
paul upon john: power to require deliver
john towards paul: liability to be required to deliver
.. time 3 
paul upon john: power to require deliver
john towards paul: liability to be required to deliver
```

_John offers, Paul accepts, Paul pays, but John does not deliver_

```---- scenario 2
.. time 0 
=> does(john, offer) 
.. time 1 
paul upon john: power to require deliver
john towards paul: liability to be required to deliver
=> does(paul, accept) 
.. time 2 
john towards paul: claim to pay
john towards paul: duty to deliver
paul towards john: claim to deliver
paul towards john: duty to pay
=> does(paul, pay), (does(john, neg(deliver)), (does(paul, fulfill(claim(john, paul, pay))), (does(john, violate(claim(paul, john, deliver))) 
.. time 3 
** VIOLATIONS ** claim(paul, john, deliver)
paul towards john: claim to deliver
john towards paul: duty to deliver
=> does(john, neg(deliver)), (does(john, violate(claim(paul, john, deliver))) 
```

