import sys
sys.path.insert(0, '../SLY')

from sly import Lexer, Parser


class Parameter:
    def __init__(self, functor, params = []):
        self.functor = functor
        self.params = params

    def __str__(self):
        output = self.functor
        if len(self.params) > 0:
            output += "(" + ", ".join([str(p) for p in self.params]) + ")"
        return output

    def __repr__(self):
        return self.__str__()


class Predicate:
    def __init__(self, pred, params = [], sign=True):
        self.sign = sign
        self.pred = pred
        self.params = params

    def __str__(self):
        output = self.pred
        if self.sign is False:
            output = "-"+output
        if len(self.params) > 0:
            output += "(" + ", ".join([str(p) for p in self.params]) + ")"
        return output

    def __repr__(self):
        return self.__str__()

    def remove_param(self, param_pos):
        return self.remove_params([param_pos])

    def remove_params(self, list_param_pos=()):
        params = []
        for i, param in enumerate(self.params):
            if i not in list_param_pos:
                params.append(param)
        return Predicate(self.pred, params, self.sign)


class PredicateLexer(Lexer):
    tokens = { NAME, COMMA, NUMBER, MINUS, LPAREN, RPAREN }
    ignore = ' \t'

    NAME = r'[a-zA-Z_][a-zA-Z0-9_]*'
    NUMBER = r'\d+'
    COMMA = r','
    MINUS = r'-'
    LPAREN = r'\('
    RPAREN = r'\)'

    def error(self, t):
        print("predicate parsing: illegal character '%s'" % t.value[0])
        self.index += 1

class PredicateParser(Parser):
    tokens = PredicateLexer.tokens

    def __init__(self):
        self.names = { }

    @_('MINUS NAME')
    def predicate(self, p):
        return Predicate(sign=False, pred=p.NAME)

    @_('NAME')
    def predicate(self, p):
        return Predicate(pred=p.NAME)

    @_('MINUS NAME LPAREN list_params RPAREN')
    def predicate(self, p):
        return Predicate(sign=False, pred=p.NAME,params=p.list_params)

    @_('NAME LPAREN list_params RPAREN')
    def predicate(self, p):
        return Predicate(pred=p.NAME,params=p.list_params)
        
    @_('param')
    def list_params(self, p):
        return [p.param]

    @_('param COMMA list_params')
    def list_params(self, p):
        return [p.param, *p.list_params]

    @_('NAME')
    def param(self, p):
        return Parameter(functor=p.NAME)

    @_('NUMBER')
    def param(self, p):
        return Parameter(functor=p.NUMBER)

    @_('NAME LPAREN list_params RPAREN')
    def param(self, p):
        return Parameter(functor=p.NAME, params=p.list_params)


if __name__ == '__main__':
    lexer = PredicateLexer()
    parser = PredicateParser()
    print(parser.parse(lexer.tokenize("p")))
    print(parser.parse(lexer.tokenize("p(o)")))
    print(parser.parse(lexer.tokenize("p(o, p)")))
    print(parser.parse(lexer.tokenize("p(o, p, c)")))
    print(parser.parse(lexer.tokenize("p(o, p(o, p))")))
    print(parser.parse(lexer.tokenize("-p")))
    print(parser.parse(lexer.tokenize("-p(o)")))
