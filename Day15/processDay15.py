import csv

# create empty arrays
inputList = []

# store the input in the array
with open('input.txt',newline='') as csvfile:
    inputReader = csv.reader(csvfile, delimiter= ',', quotechar='|')
    # store the input in the array
    for row in inputReader:
        inputRow = [int(rowVal) for rowVal in row]
        inputList.extend(inputRow)

# First half: van eck's sequence
numValList = inputList.copy()
numValList.reverse()

while len(numValList) < 2020:
    if numValList[0] in numValList[1:]:
        # Append location at start
        # print(numValList[0],' is in ', numValList[1:])
        numValList = [numValList.index(numValList[0], 1)] + numValList
    else:
        # Else append 0 at start
        # print(numValList[0],' is not in ', numValList[1:])
        numValList = [0] + numValList

print('2020th spoken number is: ', numValList[0])

# Second half
# Don't store everything to save on memory
# Hash table implementation
inputKeys = set(inputList)
inputDict = {}

# Table initialization
for inputKey in inputKeys:
    inputDict[inputKey] = inputList.index(inputKey)

# Go back a bit sice we have to treat the last entry as the current input
newInput = inputList[-1]
inputCount = len(inputList) - 1

# Keep going till we have 30 million inputs
while inputCount < 30000000:
    # The new input is the last input
    lastInput = newInput

    # Check for presence in the hash table
    if lastInput in inputKeys:
        # If present, New input is the distance to occurence
        newInput = inputCount - inputDict[lastInput]

        # Update the hash table to note that the last occurence was now
        inputDict[lastInput] = inputCount
    else:
        # If not present, add the input to the table
        inputDict[lastInput] = inputCount
        inputKeys.add(lastInput)

        # Since the input has never occurred, the new input is 0
        newInput = 0

    # Update the input count
    inputCount = inputCount + 1

# Find the 30 millionth number
print('30000000th spoken number is: ', lastInput)
print('The hash table has: ', len(inputKeys), 'entries')
