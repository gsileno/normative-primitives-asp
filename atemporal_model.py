from asp_wrapper import solve

def first_order(pos):
	# return pos.sign is True and (pos.pred == "duty" or pos.pred == "full_liberty")
	return pos.sign is True and (pos.pred == "claim" or pos.pred == "duty" or pos.pred == "full_noclaim" or pos.pred == "full_liberty")

def second_order(pos):
	# return pos.sign is True and (pos.pred == "power" or pos.pred == "full_immunity")
	return pos.sign is True and (pos.pred == "power" or pos.pred == "liability" or pos.pred == "full_disability" or pos.pred == "full_immunity")
	# return pos.sign is True and (pos.pred == "poschange_power" or pos.pred == "posforce_power" or pos.pred == "power" or pos.pred == "negchange_power" or pos.pred == "negforce_power" or pos.pred == "negpower")

def subjected(pos):
	return pos.pred == "liability" or pos.pred == "full_immunity"

def query(answer_sets):
	alternatives = []

	for i in range(len(answer_sets)):
		deontic_rels = {}
		potestative_rels = {}
		for atom in answer_sets[i]:
			if first_order(atom):
				holder = str(atom.params[0])
				counterparty = str(atom.params[1])
				action = str(atom.params[2])
				if holder not in deontic_rels:
					deontic_rels[holder] = {}
				if counterparty not in deontic_rels[holder]:
					deontic_rels[holder][counterparty] = []
				deontic_rels[holder][counterparty].append(atom)		
			elif second_order(atom):
				holder = str(atom.params[0])
				action = str(atom.params[1])
				if holder not in potestative_rels:
					potestative_rels[holder] = {}
				if action not in potestative_rels[holder]:
					potestative_rels[holder][action] = []
				potestative_rels[holder][action].append(atom)	

		alternatives.append((deontic_rels, potestative_rels))	

	return alternatives

def show(alternative):
	deontic_rels = alternative[0]
	potestative_rels = alternative[1]

	for x in deontic_rels.keys():
		for y in deontic_rels[x].keys():
			for rel in deontic_rels[x][y]:
				position = str(rel.pred) + " to " + str(rel.params[2])
				if rel.sign == False: position = "no "+position
				print("%s towards %s: %s" % (x, y, position))

	for x in potestative_rels.keys():
		for a in potestative_rels[x].keys():
			for rel in potestative_rels[x][a]:
				if rel.sign == False: position = "no "
				else: position = ""
				if subjected(rel):
					position += str(rel.pred) + " to be required to " + str(rel.params[2])
					print("%s towards %s: %s" % (x, a, position))
				else:
					position += str(rel.pred) + " to require " + str(rel.params[2])
					print("%s upon %s: %s" % (x, a, position))

def unpack(alternatives):
	for i, alternative in enumerate(alternatives):
		if len(alternatives) > 1:
			print("- configuration %d " % (i+1))
		show(alternative)
			
with open("atemporal_model.lp", 'r') as file:
    atemporal_model = file.read()

if __name__ == '__main__':
	print("==== case 1")
	case = """% deontic use case:
	agent(john). agent(paul). action(pay).
	duty(paul, john, pay)."""
	answer_sets = solve(atemporal_model+case)
	unpack(query(answer_sets))

	print("==== case 2")
	case = """% potestative use case:
	agent(john). agent(paul). action(pay).
	ability(john, require(pay), plus(claim(john, paul, pay)))."""
	answer_sets = solve(atemporal_model+case)
	unpack(query(answer_sets))

