import csv
from itertools import permutations
# create empty arrays
inputList = []

# store the input in the array
with open('input.txt',newline='') as csvfile:
    inputReader = csv.reader(csvfile, delimiter= '\n', quotechar='|')
    # store the input in the array
    for row in inputReader:
        inputList.extend(row)

#print(inputList)

# Store all the rules
rulesList = {}
allValidVals = []

# Determine rules by reading input till the 'your ticket' section comes up
while not 'your ticket' in inputList[0]:
    # pop the first entry
    row = inputList.pop(0)

    # Split the rules into a key and values
    row = row.split(':')

    # Store the key and start a dict
    keyVal = row.pop(0)
    rulesList[keyVal] = []   # initialize the valid inputs with an empty list

    # Split the values into groups
    row = row[0].split(' ')
    # The rest of the rule is a list of allowed inputs
    for ruleVal in row:
        # The or just separates two lists
        if 'or' in ruleVal:
            continue
        # For each range, create a list of valid inputs
        elif ruleVal:
            ruleVal = ruleVal.split('-')
            validInput = range(int(ruleVal[0]),int(ruleVal[1])+1,1)

            # Append the inputs to the value for the selected key
            rulesList[keyVal].extend(validInput)

        # Add all the values for this key into the valid values list
        allValidVals.extend(rulesList[keyVal])

#print(rulesList.keys())

# drop the header for 'your tickets'
inputList.pop(0)

# The next input is the data for "my" ticket
row = inputList.pop(0)
row = row.split(',')
# Make a list of all the numbers in this input
myTicket = [int(val) for val in row]

#print(myTicket)

# drop the header for 'nearby tickets'
inputList.pop(0)
nearbyTickets = []

# The rest of the inputs are all nearby tickets
while inputList:
    row = inputList.pop(0)
    row = row.split(',')

    # Make a list of all the numbers in this input
    currTicket = [int(val) for val in row]

    # Append this ticket to the full set of tickets
    nearbyTickets.append(currTicket)
#print(nearbyTickets)

# Create a list of invalid inputs
invalidValues = []
validTickets = []

# Check each 'nearby ticket' for invalid inputs
for currTicket in nearbyTickets:
    # If value is invalid, add it to the invalid values list
    currInvalid = [currVal for currVal in currTicket if not currVal in allValidVals]
    if currInvalid:
        invalidValues.extend(currInvalid)
    else:
        validTickets.append(currTicket)

# Print the sum of all these numbers as the "ticket scanning error rate"
print('First half')
print('Ticket scanning error rate = ', sum(invalidValues))

# Second half
keyOrder = {}
validKeys = []

# Find a key combo that fits the current data
# Start by finding all the valid keys for each column
for colNum in range(0, len(myTicket)):
    validKeys.append([])
    for key in rulesList.keys():
        validCheck = [1 if currTicket[colNum] in rulesList[key] else 0 for currTicket in validTickets]

        if min(validCheck):
            validKeys[-1].append(key)

# Define a set of used keys
usedKeys = set()

# Keep running till we run out of keys
while not len(usedKeys) == len(myTicket):
    newKeys = []
    for colNum in range(0, len(myTicket)):
        newKeys.append([])

        # If only one valid key exists, use it for the current column
        if len(validKeys[colNum]) == 1:
            usedKeys.add(validKeys[colNum][0])
            keyOrder[colNum] = validKeys[colNum][0]
            print(validKeys[colNum][0])
            continue
        # If a new key has been used up, cleanup all the other keys
        for currKey in validKeys[colNum]:
            if not currKey in usedKeys:
                newKeys[-1].append(currKey)

    #print(validKeys, usedKeys)
    #print(newKeys)
    # Replace the validKeys list with the new cleaned up keys
    validKeys = newKeys

if usedKeys:
    # Apply the key order to my ticket
    departureValues = [myTicketVal for valIndex, myTicketVal in enumerate(myTicket) if 'departure' in keyOrder[valIndex]]

    print(keyOrder)
    print(myTicket)
    print(departureValues)

    departureProd = 1
    while departureValues:
        departureProd = departureProd*departureValues.pop()

    print('Second half')
    print('Product of all the departure field values: ', departureProd)
else:
    print('No valid key order')
