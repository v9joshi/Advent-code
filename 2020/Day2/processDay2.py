import csv

# create an empty array
inputList = []

# store the input in the array
with open('input.txt',newline='\n') as csvfile:
    inputReader = csv.reader(csvfile, delimiter= ' ', quotechar='|')
    for row in inputReader:
        inputList.append(row)

# First half
# Initiate the fail Count
numFail = 0
numSuc = 0

# Parse the input
for passSet in inputList:
    # Determine the min and max num of reps for the char
    valCheck = passSet[0].split('-')

    minVal = int(valCheck[0])
    maxVal = int(valCheck[1])

    # What character should be repeated
    passwordChar = passSet[1][0]

    # What was the password input
    passwordToCheck = passSet[2]

    # Count the repetitions
    numReps = passwordToCheck.count(passwordChar)

    # Check that the reps meet the requirements
    if maxVal < numReps or numReps < minVal:
        numFail = numFail + 1
    else:
        numSuc = numSuc + 1
print('first half')
print('Fail = ', numFail, 'Success = ', numSuc)

# Second half
# Initiate the fail Count
numFail = 0
numSuc = 0

# Parse the input
for passSet in inputList:
    # Determine the min and max num of reps for the char
    valCheck = passSet[0].split('-')

    firstPos = int(valCheck[0])
    secondPos = int(valCheck[1])

    # What character should not repeat
    passwordChar = passSet[1][0]

    # What was the password input
    passwordToCheck = passSet[2]

    # Check that the passowrd meets the requirements
    if (passwordChar in passwordToCheck[firstPos - 1]) ^ (passwordChar in passwordToCheck[secondPos - 1]):
        numSuc = numSuc + 1
    else:
        numFail = numFail + 1

print('Second half')
print('Fail = ', numFail, 'Success = ', numSuc)
