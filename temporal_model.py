from ec_wrapper import ec_logic, solve, event_query, event_show
from atemporal_model import show, query

def configuration_show_function(configuration):
	violations = []
	case = ""
	for atom in configuration:
		if atom.functor == "violated":
			violations.append(atom.params[0]) 
		else:
			case += str(atom)+".\n"

	if len(violations) > 0:
		print("** VIOLATIONS ** " + ", ".join([str(p) for p in violations]))

	answer_sets = solve(atemporal_model+case)
	alternatives = query(answer_sets)
	if len(alternatives) > 1:
		raise RuntimeError("Unexpected non-deterministic solution")
	show(alternatives[0])

with open("atemporal_model.lp", 'r') as file:
    atemporal_model = file.read()
with open("temporal_model_bridge.lp", 'r') as file:
    temporal_model = file.read()

if __name__ == '__main__':
	print("==== case 1: simple power ====\n")
	case = """% potestative use case:
	agent(john). agent(paul). action(pay). action(require(pay)).
	holds(ability(john, require(pay), plus(claim(john, paul, pay))), 0).
	time(0..1)."""
	answer_sets = solve(ec_logic+temporal_model+case)
	actors, actions, fluents, alternative_scenarios = event_query(answer_sets)
	event_show(actors, actions, fluents, alternative_scenarios, configuration_show_function, newline=True)
	print("\n\n")

	print("==== case 2: simple prohibition ====\n")
	case = """agent(john). agent(paul). action(pay). 
	holds(claim(john, paul, neg(pay)), 0).
	time(0..1)."""
	answer_sets = solve(ec_logic+temporal_model+case)
	actors, actions, fluents, alternative_scenarios = event_query(answer_sets)
	event_show(actors, actions, fluents, alternative_scenarios, configuration_show_function, newline=True)
	print("\n\n")

	print("==== case 3: simple duty ====\n")
	case = """agent(john). agent(paul). action(pay).
	holds(claim(john, paul, pay), 0).
	time(0..1)."""
	answer_sets = solve(ec_logic+temporal_model+case)
	actors, actions, fluents, alternative_scenarios = event_query(answer_sets)
	event_show(actors, actions, fluents, alternative_scenarios, configuration_show_function, newline=True)
	print("\n\n")

	print("==== case 4: sale transaction ====\n")
	case = """% sale transaction
	agent(john). agent(paul). action(offer). action(accept). action(pay). action(deliver).
	holds(ability(john, offer, plus(ability(paul, accept, plus(claim(john, paul, pay))))), 0).
	holds(ability(john, offer, plus(ability(paul, accept, plus(claim(paul, john, deliver))))), 0).
	time(0..3)."""
	answer_sets = solve(ec_logic+temporal_model+case)
	actors, actions, fluents, alternative_scenarios = event_query(answer_sets)
	event_show(actors, actions, fluents, alternative_scenarios, configuration_show_function, newline=True)
	print("\n\n")


