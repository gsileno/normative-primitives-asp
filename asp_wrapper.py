from clingo import Control

from predicate import PredicateParser, PredicateLexer

lexer = PredicateLexer()
parser = PredicateParser()

def parse_answer(code):
    return parser.parse(lexer.tokenize(code))

class Program:
    # -- Fields --
    # rule_list
    def __init__(self, code):
        self.code = code
        self.answer_sets = []
        self.errors = []

    def logger(self, code, message):
        self.errors.append(message)

    def __on_model(self, model):
        answer_set = []
        for atom in model.symbols(atoms="True"):
            answer_set.append(parse_answer(str(atom)))
        self.answer_sets.append(answer_set)

    def solve(self):
        ctl = Control(logger=self.logger)
        ctl.configuration.solve.models = 0  # to obtain all answer sets
        try:
            ctl.add("base", [], self.code)
        except RuntimeError:
            print(self.errors)
            exit()

        ctl.ground([("base", [])])
        ctl.solve(on_model=self.__on_model)
        return self.answer_sets


# given an ASP program, solve it and print the answer sets
def solve(code):
    program = Program(code)
    return program.solve()
    
# solve an ASP program given as a file and print the outpupt
def solve_file(filename):
    with open(filename, 'r') as myfile:
        code = myfile.read()
        solve(code)

if __name__ == '__main__':
    print(solve("mortal(X) :- man(X). man(socrates)."))
