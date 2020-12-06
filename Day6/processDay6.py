import csv

# create an empty array
inputList = []

# store the input in the array
with open('input.txt',newline='') as csvfile:
    inputReader = csv.reader(csvfile, delimiter= ' ', quotechar='|')
    for row in inputReader:
        inputList.append(row)

# Clean up the input to put responses from each group together
responseList = [[]]
for currInput in inputList:
    if currInput: # non empty responses should get grouped together
        responseList[-1].extend(currInput)
    else: # empty response indicate switching to a new group
        responseList.append([])

# First half
# For each member of the list, convert to a set to find unique responses
# then measure the size of the set to find the number of unique responses
uniqueList = []
uniqueCount = []

for currVal in responseList:
    # Covert all responses from a single group to a string
    currVal = "".join(currVal)

    # Turn the string into a set to find unique responses
    uniqueList.append(set(currVal))

    # The length of the set equals the number of unique responses
    uniqueCount.append(len(set(currVal)))

# Print the result
print("Total number of yes responses = ", sum(uniqueCount))

# Second half
# For each group find questions where the number of yes responses equals the
# size of the group
allYesCount = []

for groupResponse in responseList:
    # How many questions did everyone in the group answer yes to?
    numAllYes = 0

    # How many people are in the group?
    groupSize = len(groupResponse)

    # Combine the group response into a single string
    currVal = "".join(groupResponse)

    # Find all the unique responses for the group
    uniqueVal = set(currVal)

    # For each unique response check if the number of yes response
    # equals the group size
    for responseVal in uniqueVal:
        if currVal.count(responseVal) == groupSize:
            numAllYes = numAllYes + 1

    # Append the yes count for the group to the full yes count list
    allYesCount.append(numAllYes)

# Print the result
print("Total number of yes responses from all groups:", sum(allYesCount))
