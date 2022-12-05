f = open('input.txt')
raw = f.read()
rules, data = raw.split('\n\n')

rules = rules.replace('"a"', 'a')
rules = rules.replace('"b"', 'b')

ruleset = {}
for rule in rules.splitlines():
    p1, p2 = rule.split(': ')
    ruleset[p1] = p2

print(ruleset)
