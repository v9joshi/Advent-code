import csv
from itertools import combinations

# Function to check if the currNumber is a valid input given prevNumbers were
# the most recent inputs.
# Rule: currNumber must be the sum of any two of prevNumbers
def isInputAllowed(currInput, prevInputs):
    return [pair for pair in combinations(prevInputs, 2) if sum(pair) == currInput]

# create an empty array
inputList = []

# store the input in the array
with open('input.txt',newline='') as csvfile:
    inputReader = csv.reader(csvfile, delimiter= ' ', quotechar='|')
    # store the input in the array
    for row in inputReader:
        if row:
            # Store the list of "transmitted" integers
            inputList.append(int(row[0]))

# First half: Find the first number that doesn't fit the rule.
# Rule: number i must be the sum of any two of prev preambleSize numbers
# What is the preamble size?
preambleSize = 25

# The first non-preamble input is at currIndex
currIndex = preambleSize

# If the input is allowed increase currIndex by 1, otherwise stop.
while isInputAllowed(inputList[currIndex], inputList[(currIndex - preambleSize):(currIndex)]):
    currIndex = currIndex + 1

firstInvalidInput =  inputList[currIndex]

print('First invalid input : ', firstInvalidInput)

# Second half: find sum of smallest and largest number in contList
# Where contList is a list of contiguous numbers that sum to the first invalid
# number found from part 1.
# Start by checking all lists of size 3
listSize = 3
contList = []

# Loop till we get a valid contList
while not contList:
    # Find all contiguous lists of length listSize in inputList
    allowedLists = [inputList[startIndex:(startIndex + listSize)] for startIndex in range(0,currIndex - listSize)]

    # Find a list in allowedList for which the sum of all elements
    # is the answer for the first half
    contList = [testList for testList in allowedLists if sum(testList) == firstInvalidInput]

    # Increase listSize
    listSize = listSize + 1

    # if listSize is greater than currIndex, no contList exists
    if listSize > currIndex:
        break

# If a solution exists, find the sum of the min and max element
if contList:
    print('The sum of the smallest and largest number in the list is ', min(contList[0]) + max(contList[0]))
    print('The contiguous list is: ', contList[0])
else:
    print('No solution found')
