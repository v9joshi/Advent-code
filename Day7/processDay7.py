import csv

# create an empty array
inputList = []
outerBagList = []
innerBagList = []

# store the input in the array
with open('input.txt',newline='') as csvfile:
    inputReader = csv.reader(csvfile, delimiter= ' ', quotechar='|')
    # store the input in the array
    for row in inputReader:
        if row:
            # Store the list of rules
            inputList.append(row)
            row = ''.join(row)

            # Store a list of outer bags
            outerBag = row.split('contain')[0]
            outerBagList.append(outerBag[0:-1])

            # Store the rule for inner bags corresponding to the outerBag
            innerBag = (row.split('contain')[1]).split(',')
            innerBagList.append(innerBag)

# Make a lookup table from the list of rules
# The values in location(rowNum, colNum) correspond to the number of bags of
# color outerBagList(colNum) stored in a bag of color outerBagList(rowNum)
lookupTable = []
for [outerBag, innerBag] in zip(outerBagList, innerBagList):
    # For each outerBag add a row to the lookup table
    lookupTable.append([])
    # Traverse the columns of the lookup table
    for bagColor in outerBagList:
        # For the selected bagColor, how many bags of this color does outerBag contain?
        numContained = sum([int(numBags[0]) if bagColor in numBags else 0 for numBags in innerBag])
        lookupTable[-1].extend([numContained])

# First half: How many outer bags can a bag of color 'shinygold' be stored in?
# Find the index corresponding to 'shinygold'
originalBag = [bagNum for bagNum, bagColor in enumerate(outerBagList) if 'shinygold' in bagColor]

# Create a set of all the possible outer bags
startSet = {}
newSet = set(originalBag)

# Keep looping through the rules till the size of the set stops changing
while not newSet.issubset(startSet):
    # Make the start set a copy of the new set
    startSet = newSet.copy()

    # Traverse all the rules as described by lookupTable
    for rowNum in range(len(lookupTable)):
        # If the bag of color bagColor(rowNum) contains any of the bags in
        # startSet, add it to newSet
        numSetElementsContained = sum(lookupTable[rowNum][colNum] for colNum in list(startSet))
        if numSetElementsContained > 0:
            newSet.add(rowNum)

# Original bag can't be in set unless it contains one of the other elements
# of the set.
numSetElementsContained = sum(lookupTable[originalBag[0]][colNum] for colNum in list(newSet))
if numSetElementsContained == 0:
    newSet.remove(originalBag[0])
else:
    print("Selected bag can contain itself")

# Print the result
print("Number of possible outer bags for shiny gold bag = ", len(newSet))

# Second half: How many bags does the selected bag contain?
# Note: This solution assumes a non-looping input, for general use it would be
#       important to check for loops in the rules, i.e. bags that can contain
#       themselves. Such bags would contain infinite bags and produce infinite
#       recursion. A simple linal method, probably |max(eig)| < 1 could check
#       for such loops.
#
# Find the index corresponding to 'shinygold'
originalBag = [bagNum for bagNum, bagColor in enumerate(outerBagList) if 'shinygold' in bagColor]

# We're going to use recursion to calculate the total number of bags needed
# Define a function to count the number of bags contained within currBag for
# the set of rules given by lookupTable
def numBagsContained(currBag, lookupTable):
    # Initialize our bag count with 0
    numBags = 0

    # Read the rules for currBag as listed in lookupTable[currBag]
    for bagNum, bagCount in enumerate(lookupTable[currBag]):
        # If the bag isn't present, do not change the count of numBags
        if bagCount == 0:
            numBags = numBags
        # If the bag is present, add the number of such bags to the total numBags
        # but also find out how many bags this new bag contains
        # i.e. call this function again.
        else:
            numBags = numBags + bagCount*(1 + numBagsContained(bagNum, lookupTable))
    # Once all the rules have been traversed, we can return the total numBags
    return numBags

# Print the result
print("Number of bags stored within shiny gold bag = ", numBagsContained(originalBag[0], lookupTable))
