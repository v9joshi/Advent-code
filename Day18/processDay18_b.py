import csv
# create empty arrays
inputList = []

def removeParan(inputExpression):
    # Remove all parantheses
    while '(' in inputExpression:
        # Start by locating a closing paran
        endPos = 0
        while not inputExpression[endPos] == ')':
            endPos = endPos + 1

        # Find the matching opening paran
        startPos = endPos
        while not inputExpression[startPos] == '(':
            startPos = startPos - 1

        inputExpression[startPos:endPos+1] = [doMath(0, inputExpression[startPos+1:endPos])]

    #print('parans removed : ',inputExpression)
    return inputExpression

def removePlus(inputExpression):
    # Remove all pluses
    # First turn everything into strings
    for currPos, currVal in enumerate(inputExpression):
        if not isinstance(currVal, str):
            inputExpression[currPos] = str(currVal)

    while '+' in inputExpression:
        print(inputExpression)
        # Start by locating a plus
        plusPos = 0
        while not inputExpression[plusPos] == '+':
            plusPos = plusPos + 1

        # Find the numberAfter
        endPos = plusPos
        while (not inputExpression[endPos].isdigit()) or inputExpression[endPos] == ' ':
            endPos = endPos + 1

        startPos = plusPos
        while (not inputExpression[startPos].isdigit()) or inputExpression[startPos] == ' ':
            startPos = startPos - 1

        inputExpression[startPos:endPos+1] = [''.join(str(int(inputExpression[startPos]) + int(inputExpression[endPos])))]

    print('plus removed : ',inputExpression)
    return inputExpression

def doMath(initVal, inputExpression):
    removePlus(inputExpression)

    while inputExpression:
        print(initVal, inputExpression)
        currVal = inputExpression.pop(-1)
        if isinstance(currVal, int):
            initVal = currVal
        elif currVal == '+':
            initVal = initVal + doMath(0,inputExpression)
        elif currVal == '*':
            initVal = initVal * doMath(0,inputExpression)
        elif currVal == ' ':
            initVal = initVal
        elif currVal.isdigit():
            initVal = int(currVal)

    print('return ', initVal)
    return initVal

# store the input in the array
with open('input.txt',newline='') as csvfile:
    inputReader = csv.reader(csvfile, delimiter= '\n', quotechar='|')
    # store the input in the array
    for row in inputReader:
        inputList.append(row[0])

evalList = []
for expression in inputList:
    print(expression)
    inputExpression = removeParan(list(expression))
    evalList.append(doMath(0, inputExpression))
    print('####')
    print(expression, ' = ', evalList[-1])
    print('####')

print('Second half:')
print('Sum of all ans: ', sum(evalList))
