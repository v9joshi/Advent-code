import csv
from math import factorial
from itertools import combinations


# create an empty array
inputList = []

# store the input in the array
with open('input.txt',newline='') as csvfile:
    inputReader = csv.reader(csvfile, delimiter= ' ', quotechar='|')
    # store the input in the array
    for row in inputReader:
        if row:
            # Store the list of "trasmitter joltages"
            inputList.append(int(row[0]))

# Define known constants
outletJoltage = 0
adapterJoltage = inputList

# set the device joltage
deviceJoltage = max(adapterJoltage) + 3

# Add the device joltage and outlet joltage to the list
adapterJoltage.append(outletJoltage)
adapterJoltage.append(deviceJoltage)

# Sort the list and find the difference between consecutive elements
adapterJoltage.sort()
joltDiffList = [higherVal - lowerVal for lowerVal, higherVal in zip(adapterJoltage[:-1], adapterJoltage[1:])]

# First half
# Find the number of 1s and 3s in the list
oneCount = joltDiffList.count(1)
threeCount = joltDiffList.count(3)

print("There are ", oneCount, ' ones and', threeCount, ' threes. The product is ', oneCount*threeCount)

# Second half
validAdapterConnections = {}
currNodeVal = inputList[-1]
inputList.pop(-1)

while inputList:
    # How many combos for next segment?
    validAdapters = [currAdapter for currAdapter in inputList if currNodeVal - currAdapter <= 3]

    if validAdapters:
        validAdapterConnections[currNodeVal] = (validAdapters)
        currNodeVal = inputList[-1]
        inputList.pop(-1)

#print(validAdapterConnections)

# Find the number of paths in the graph that go from currAdapter to deviceJoltage
# The graph connections are listed in validAdapterConnections
def numConnections(currAdapter, validAdapterConnections, nodePathCount):
    if currAdapter in nodePathCount.keys():
            return nodePathCount[currAdapter]
    elif currAdapter in validAdapterConnections.keys():
        # Initialize path count
        numPaths = 0
        for nextAdapter in validAdapterConnections[currAdapter]:
            numPaths = numPaths + numConnections(nextAdapter, validAdapterConnections, nodePathCount)

        # Return the number of paths found
        nodePathCount[currAdapter] = numPaths
        return numPaths
    else:
        return 0

nodePathCount = {0: 1}
print("There are ", numConnections(deviceJoltage, validAdapterConnections, nodePathCount), " valid connections")
#print('Number of combos = ', numConnections)
