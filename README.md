# Normative primitives in ASP

ASP logic programs and Python helpers for normative reasoning. 

## Logic programs

- `atemporal_model.lp` contains axioms for:
  - Hohfeld's framework of primitive concepts
  - Aristotelian squares constructed over primitive concepts (deontic, force power, outcome power, change power)
  - closure norms (liberty and disabbility)
  - full liberty and full disability
- `event_calculus.lp` contains simple event calculus axioms adjusted for agents performing actions.
- `temporal_model_bridge.lp` contains bridging axioms from normative concepts to event calculus (eg. `ability` to `initiates`)

## Python helpers

- `asp_wrapper.py` runs the solver for ASP programs and collect answers set in easily reusable data structures. 
- `ec_wrapper.py` runs and visualizes dynamic models based on event calculus.
- `atemporal_model.py` runs and visualizes normative reasoning on static scenarios
- `temporal_model.py` runs and visualizes normative reasoning on dynamic scenarios via event calculus

## dependencies

you need to install the ASP solver `clingo`, eg. by means of Anaconda:
```
conda install -c potassco clingo
``` 

Predicates expressed in answer sets are parsed via SLY (https://github.com/dabeaz/sly). Download it on your computer.
Update `sys.path.insert(0, '../SLY')` at the beginning of `predicate.py` with your directory.

