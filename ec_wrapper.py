from asp_wrapper import solve

def event_query(answer_sets):
    actors = []
    actions = []
    fluents = []

    alternative_scenarios = []

    for i in range(len(answer_sets)):
        fluents_in_time = {}
        actions_in_time = {}
        options_in_time = {}
        atoms = []
        for atom in answer_sets[i]:
            if (atom.pred == "holds") and atom.sign is True:
                fluent = str(atom.params[0])
                time = int(str(atom.params[1]))
                if time not in fluents_in_time:
                    fluents_in_time[time] = []
                assert fluent not in fluents_in_time[time]
                fluents_in_time[time].append(atom.params[0])
            elif atom.pred == "does" or atom.pred == "cdoes":
                time = int(str(atom.params[2]))
                if time not in actions_in_time:
                    actions_in_time[time] = []
                actions_in_time[time].append(atom.remove_param(2)) # remove time 
            elif atom.pred == "initiates" or atom.pred == "terminates":
                time = int(str(atom.params[3]))
                if time not in options_in_time:
                    options_in_time[time] = []
                options_in_time[time].append(atom.remove_param(3)) # remove time 
            elif atom.pred == "agent":
                actor = str(atom.params[0])
                if actor not in actors:
                    actors.append(actor)
            elif atom.pred == "action":
                action = str(atom.params[0])
                if action not in actions:
                    actions.append(action)
            elif atom.pred == "fluent":
                fluent = str(atom.params[0])
                if fluent not in fluents:
                    fluents.append(fluent)

        alternative_scenarios.append((fluents_in_time, actions_in_time, options_in_time))

    return (actors, actions, fluents, alternative_scenarios)
 
def event_show(actors, actions, fluents, alternative_scenarios, fluent_show_function = None, show_options = False, newline = True):
    print("actors: %s" % ", ".join(actors))
    print("actions: %s" % ", ".join(actions))
    print("fluents: %s" % ", ".join(fluents))

    for i, scenario in enumerate(alternative_scenarios):
        if len(alternative_scenarios) > 1: 
            print("---- scenario %d " % (i+1))

        fluents_in_time = scenario[0]
        actions_in_time = scenario[1]
        options_in_time = scenario[2]

        path = []    
        states = []
        for t in range(len(fluents_in_time.keys())):
            states.append(fluents_in_time[t])
            if t in actions_in_time:
                path.append(actions_in_time[t])

        for time in range(len(states)):
            if newline: 
                print(".. time %d " % (time))
                if fluent_show_function is None:
                    for fluent in states[time]:
                        print(fluent)
                else:
                    fluent_show_function(states[time])
                if time < len(path):
                    print("=> %s " % ", (".join([str(s) for s in path[time]]))
            else:
                if time < len(path):
                    print(".. time %d: %s => %s =>  " % (time, ", ".join([str(f) for f in states[time]]), ", ".join([str(s) for s in path[time]])))
                else:
                    print(".. time %d: %s" % (time, ", ".join([str(f) for f in states[time]])))

        # if fluent_show_function is None:
        #     fluent_show(fluents_in_time)
        # else:
        #     fluent_show_function(fluents_in_time)

        if show_options: print(options_in_time)

with open("event_calculus.lp", 'r') as file:
    ec_logic = file.read()

if __name__ == '__main__':
    print("==== Yale shooting problem")
    case = """
    initiates(X, load, loaded, T) :- agent(X), time(T), not holds(loaded, T). 
    terminates(X, shoot, loaded, T) :- holds(loaded, T), agent(X), time(T).
    terminates(X, shoot, alive, T) :- holds(alive, T), holds(loaded, T), agent(X), time(T).
    holds(dead, T) :- not holds(alive, T), time(T).
    agent(john). action(load). action(shoot).
    holds(alive, 0). 
    time(0..2).
    """

    answer_sets = solve(ec_logic+case)
    actors, actions, fluents, alternative_scenarios = event_query(answer_sets)
    event_show(actors, actions, fluents, alternative_scenarios)
