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
# First we will make a dictionary to store the directed graph of valid adapter
# connections. We can either start at the device or the outlet.
validAdapterConnections = {}

# Start at the device
currNodeVal = inputList[-1]
inputList.pop(-1)

# Iterate through all the adapters and find valid connections for them
while inputList:
    # How many valid connections exist for this adapter towards the outlet?
    validAdapters = [currAdapter for currAdapter in inputList if currNodeVal - currAdapter <= 3]

    # Add all of these connections into a dictionary for the current adapter
    # so that the dictionary reads
    # validAdapterConnections[currNodeVal] = (validAdapters)
    if validAdapters:
        validAdapterConnections[currNodeVal] = (validAdapters)

        # update the current adapter variable
        currNodeVal = inputList[-1]

        # Remove the last adapter from the input list so we don't visit it again
        inputList.pop(-1)

# Find the number of paths in the graph that go from currAdapter to any adapter
# for which we already know the number of paths to the outlet.
# The graph connections are listed in validAdapterConnections
# The number of paths to the outlet for a given adapter are stored in
# nodePathCount.
def numConnections(currAdapter, validAdapterConnections, nodePathCount):
    # If we have already visited the adapter, do not re-do the math, just
    # re-use the value we have already calculated
    if currAdapter in nodePathCount.keys():
            return nodePathCount[currAdapter]

    # If we haven't visited the adapter, check if it is a valid adapter
    # If it is, then count the paths leading from it to the outlet.
    elif currAdapter in validAdapterConnections.keys():
        # Initialize path count
        numPaths = 0
        for nextAdapter in validAdapterConnections[currAdapter]:
            numPaths = numPaths + numConnections(nextAdapter, validAdapterConnections, nodePathCount)

        # Store the result in nodePathCount so that we don't recalculate
        nodePathCount[currAdapter] = numPaths

        # Return the result
        return numPaths
    # If this isn't a valid adapter, then there are no paths from it.
    else:
        return 0

# Initialize nodePathCount with the information that anything directly connected
# to the outlet has one path to the outlet.
nodePathCount = {outletJoltage: 1}

# Find the total number of paths from device to outlet
print("There are ", numConnections(deviceJoltage, validAdapterConnections, nodePathCount), " valid connections from device to outlet")
