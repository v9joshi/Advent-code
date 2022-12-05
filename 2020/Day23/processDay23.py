#input = [3,8,9,1,2,5,4,6,7]
input = [5,8,3,9,7,6,2,4,1]

otherInput = [i for i in range(10,1000001)]
input.extend(otherInput)

numMoves = 0
maxMoves = 10000000

def whatComesAfter1(inputDict, count = 9):
    pickUp = [inputDict[1]]
    for i in range(count-1):
        pickUp.append(inputDict[pickUp[-1]])

    return pickUp

# Implement a linked list using dictionaries
inputDict = dict(zip(input[:-1], input[1:]))
inputDict[input[-1]] = input[0]

# Start at the beginning
currVal = input[0]

# Keep making moves till we reach maxMoves
while numMoves < maxMoves:
    # Pick up 3 cups
    pickUp = [inputDict[currVal]]
    for i in range(2):
        pickUp.append(inputDict[pickUp[-1]])

    # Squeeze the dict together
    #print(currVal)
    #print(pickUp)
    inputDict[currVal] = inputDict[pickUp[-1]]

    # Locate the destination cup
    destinationCupVal = currVal - 1
    while (destinationCupVal in pickUp) or (destinationCupVal <= 0):
        # Keep decreasing the value till we find one that wasn't picked up
        destinationCupVal -= 1

        # If you hit 0, wrap around to the top
        if destinationCupVal <= 0:
            destinationCupVal = max(input)

    #print(destinationCupVal)
    # Put the items back
    tempVal = inputDict[destinationCupVal]
    inputDict[destinationCupVal] = pickUp[0]
    inputDict[pickUp[-1]] = tempVal

    currVal = inputDict[currVal]
    # Increase numMoves
    numMoves += 1

print('First half')
print('Resulting string is: ', *whatComesAfter1(inputDict,10), sep ='')

print('Second half')
answerList = whatComesAfter1(inputDict,2)
print('Resulting numbers are: ', answerList)
print('Resulting Product is: ', answerList[0]*answerList[1])
