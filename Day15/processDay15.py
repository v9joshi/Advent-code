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
inputKeys = set(inputList)
inputDict = {}

for inputKey in inputKeys:
    inputDict[inputKey] = inputList.index(inputKey)

newInput = inputList[-1]
inputCount = len(inputList) - 1

while inputCount < 30000000:
    lastInput = newInput

    if lastInput in inputKeys:
        newInput = inputCount - inputDict[lastInput]
        inputDict[lastInput] = inputCount
    else:
        inputDict[lastInput] = inputCount
        inputKeys.add(lastInput)
        newInput = 0

    inputCount = inputCount + 1


print('2020th spoken number is: ', lastInput)
