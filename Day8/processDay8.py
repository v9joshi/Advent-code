import csv

def runConsole(inputList, currLine, acc, prevLines):
    # Check for infinite loop
    if currLine in prevLines:
        return acc, 0 # Return acc, and exit with code 0
    else:
        # Read the current command
        currCommand = inputList[currLine]

        # Store the current line number in set of visited lines
        prevLines.add(currLine)

        # Parse the command and perform the required action
        if currCommand[0]=='nop':
            currLine = currLine + 1
        elif currCommand[0] =='acc':
            currLine = currLine + 1
            acc = acc + int(currCommand[1])
        elif currCommand[0] == 'jmp':
            currLine = currLine + int(currCommand[1])

        if currLine == len(inputList):
            return acc, 1 # code ran correctly, return acc and exit code 1
        else:
            return runConsole(inputList, currLine, acc, prevLines)

# create an empty array
inputList = []

# store the input in the array
with open('input.txt',newline='') as csvfile:
    inputReader = csv.reader(csvfile, delimiter= ' ', quotechar='|')
    # store the input in the array
    for row in inputReader:
        if row:
            # Store the list of rules
            inputList.append(row)

# First half
# Initialize the accumulator
acc = 0

# Start at the first line, go through the list of inputs and execute the command
currLine = 0
prevLines = set()
acc, exitCode = runConsole(inputList, currLine, acc, prevLines)
if exitCode == 0:
    print('Accumulator value just before loop = ', acc)
else:
    print('Accumulator value at end = ', acc)

# Second half
# Find all the lines visited in the infinite loop
loopLines = prevLines.copy()

# Go through the commands and change them one at a time to see which
# one needs to be fixed
for changedLine in loopLines:
    # What command does this line have?
    currCommand = inputList[changedLine]

    print('Test line number', changedLine + 1)
    if currCommand[0] == 'acc':
        continue
    elif currCommand[0] == 'nop':
        currCommand[0] = 'jmp'
    elif currCommand[0] == 'jmp':
        currCommand[0] = 'nop'
    else:
        print('unrecognized command')
        break
    newInputList = inputList.copy()
    newInputList[changedLine] = currCommand

    # initialize accumulator
    acc = 0

    # Start from the beginning and check if we get an infinite loop
    currLine = 0
    prevLines = set()

    acc, exitCode = runConsole(newInputList, currLine, acc, prevLines)

    # If we don't get an infinite loop, print the result and break
    if exitCode == 1:
        print('Changed line is #', changedLine + 1)
        print('Accumulator value for full code = ',acc)
        break
