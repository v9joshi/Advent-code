import csv
import re

# create empty arrays
inputList = []

# store the input in the array
with open('input.txt',newline='') as csvfile:
    inputReader = csv.reader(csvfile, delimiter= ' ', quotechar='|')
    # store the input in the array
    for row in inputReader:
        inputList.append(row)

# We want to represent everything as a 36 bit binary number
formatString = "{0:036b}"

# First half
memPos = []
memVal = []

# Read the lines of code, find the mask, apply the mask to the values
# Store the values in the designated memory locations.
for memStore in inputList:
    if memStore[0] == 'mask':
        mask = memStore[2]
    else:
        bitVal = formatString.format(int(memStore[2]))
        memPos.append(int(re.search('mem\[(.+?)\]', memStore[0]).group(1)))

        maskedVal = [currBit if currMask == 'X' else currMask for currBit, currMask in zip(bitVal, mask)]
        maskedVal = ''.join(maskedVal)

        memVal.append(int(maskedVal,2))

mem = [0]*(max(memPos) + 1)

for pos, val in zip(memPos, memVal):
    mem[pos] = val

print('First half')
print('Sum of all stored values is: ', sum(mem))

# Second half
memPos = []
memVal = []

# Read the lines of code, find the mask, apply the mask to the values
# Store the values in the designated memory locations.
for memStore in inputList:
    if memStore[0] == 'mask':
        mask = memStore[2]
    else:
        bitPos = formatString.format(int(re.search('mem\[(.+?)\]', memStore[0]).group(1)))
        bitVal = int(memStore[2])

        maskedVal = [currMask if currMask == 'X' or currMask == '1' else currBit for currBit, currMask in zip(bitPos, mask)]
        numFloats = maskedVal.count('X')

        for currFloat in range(2**numFloats):
            bitFloat = bin(currFloat)[2:]
            bitFloat = bitFloat.zfill(numFloats)
            splitFloat = [currBit for currBit in bitFloat]
            newMask = [splitFloat.pop(0) if currMask == 'X' else currMask for currMask in maskedVal]

            memPos.append(int(''.join(newMask),2))
            memVal.append(bitVal)

# Find the sum
sumVal = 0
memList = []
while memPos:
    if memPos[-1] in memList:
        memPos.pop()
        memVal.pop()
        continue
    else:
        memList.append(memPos.pop())
        sumVal = sumVal + memVal.pop()

print('Second half')
print('Sum of all stored values is: ', sumVal)
