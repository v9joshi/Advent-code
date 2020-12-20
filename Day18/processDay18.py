import csv
# create empty arrays
inputList = []

# Remove all the parantheses from the input expression
def removeParan(inputExpression):
    # Remove all parantheses
    # If a paran exists find the expression it contains
    while '(' in inputExpression:
        # Start by locating a closing paran
        endPos = 0
        while not inputExpression[endPos] == ')':
            endPos = endPos + 1

        # Find the matching opening paran
        startPos = endPos
        while not inputExpression[startPos] == '(':
            startPos = startPos - 1

        # Replace the expression in the parans with the corresponding value
        inputExpression[startPos:endPos+1] = [doMath(0, inputExpression[startPos+1:endPos])]

    #print('parans removed : ',inputExpression)
    # Return the paransless expression
    return inputExpression

# Evaluate the expression
def doMath(initVal, inputExpression):

    # While there are terms in the expression eval from right to left
    while inputExpression:
        #print(initVal, inputExpression)
        # Pop the last term of the expression
        currVal = inputExpression.pop(-1)

        # Evaluate the term
        # If int, then this is the initial value
        if isinstance(currVal, int):
            initVal = currVal
        # If + sign, store the number, add to rest of expression
        elif currVal == '+':
            initVal = initVal + doMath(0,inputExpression)
        # If * sign, store the number, multiply with rest of expression
        elif currVal == '*':
            initVal = initVal * doMath(0,inputExpression)

        # Empty string, do nothing
        elif currVal == ' ':
            initVal = initVal

        # If the input is a string with a digit, convert to a number
        elif currVal.isdigit():
            initVal = int(currVal)

    #print('return ', initVal)
    # Return the result of the eval
    return initVal

# store the input in the array
with open('input.txt',newline='') as csvfile:
    inputReader = csv.reader(csvfile, delimiter= '\n', quotechar='|')
    # store the input in the array
    for row in inputReader:
        inputList.append(row[0])

# Make an empty list of expression eval results
evalList = []

# For each experssion:
for expression in inputList:
    # Start by removing the parantheses
    inputExpression = removeParan(list(expression))
    # One parans have been removed, solve the expression
    evalList.append( doMath(0, inputExpression))

    # Fancy printing
    print(expression, ' = ', evalList[-1])

# Print the sum of all results
print('First half:')
print('Sum of all ans: ', sum(evalList))
