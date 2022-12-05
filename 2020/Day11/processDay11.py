import csv
from itertools import dropwhile
from itertools import takewhile

# create an empty array
inputList = []

# store the input in the array
with open('input.txt',newline='') as csvfile:
    inputReader = csv.reader(csvfile, delimiter= ' ', quotechar='|')
    # store the input in the array
    for row in inputReader:
        # Store the list of "trasmitter joltages"
        seatMap = row[0]
        seatMap = seatMap

        inputList.append(seatMap)

# Pre-process
numRows = len(inputList)
numCols = len(inputList[0])

# Pad the inputList with 0s
inputList = [''.join(['0', currRow, '0']) for currRow in inputList]
inputList.insert(0, '0'*(numCols + 2))
inputList.append('0'*(numCols + 2))

# First half

# Step 1 fill all the seats
seatMap = inputList.copy()
seatMap = [list(currRow.replace('L','#')) for currRow in seatMap]

while 1:
    newMap = [seatRow.copy() for seatRow in seatMap]
    for rowIndex in range(1,numRows+1):
        for colIndex in range(1,numCols+1):
            allAdjacent = [seatMap[rowIndex + i][colIndex + j] for i,j in [(-1,-1),(-1,0),(-1,1),(0,-1),(0,1),(1,-1),(1,0),(1,1)]]
            # print(seatMap[rowIndex][colIndex], '->',''.join(allAdjacent))
            if seatMap[rowIndex][colIndex] == 'L' and allAdjacent.count('#') == 0:
                newMap[rowIndex][colIndex] = '#'
            elif seatMap[rowIndex][colIndex] == '#' and allAdjacent.count('#') >= 4:
                newMap[rowIndex][colIndex] = 'L'

    fullList_seatMap = [''.join(seatRow) for seatRow in seatMap]
    fullList_newMap = [''.join(newRow) for newRow in newMap]
    if fullList_seatMap == fullList_newMap:
        break
    else:
        seatMap = newMap.copy()

numOccupied = 0
for rowIndex in range(1,numRows+1):
    numOccupied = numOccupied + seatMap[rowIndex].count('#')

print('First half')
print('Number of occupied seats = ', numOccupied)


# Second half

# Step 1 fill all the seats
seatMap = inputList.copy()
seatMap = [list(currRow.replace('L','#')) for currRow in seatMap]

def cleanList(seatList):
    seatString = ''.join(seatList)
    seatString = seatString.replace('0','')
    seatString = seatString.replace('.','')
    return list(seatString)

while 1:
    newMap = [seatRow.copy() for seatRow in seatMap]

    for rowIndex in range(1,numRows+1):
        for colIndex in range(1,numCols+1):
            toLeft = seatMap[rowIndex][1:colIndex]
            toLeft = cleanList(toLeft)
            if toLeft:
                toLeft = toLeft[-1]

            toRight = seatMap[rowIndex][colIndex+1:-1]
            toRight = cleanList(toRight)
            if toRight:
                toRight = toRight[0]

            toTop = [seatMap[currRow][colIndex] for currRow in range(1,rowIndex)]
            toTop = cleanList(toTop)
            if toTop:
                toTop = toTop[-1]

            toBot = [seatMap[currRow][colIndex] for currRow in range(rowIndex+1,numRows+1)]
            toBot = cleanList(toBot)
            if toBot:
                toBot = toBot[0]

            rightUp = [seatMap[rowIndex+currRow][colIndex-currRow] for currRow in range(-min(rowIndex,numCols+1-colIndex),0)]
            rightUp = cleanList(rightUp)
            if rightUp:
                rightUp = rightUp[-1]

            leftDown = [seatMap[rowIndex+currRow][colIndex-currRow] for currRow in range(1,min(numRows+1-rowIndex, colIndex)+1)]
            leftDown = cleanList(leftDown)
            if leftDown:
                leftDown = leftDown[0]

            leftUp = [seatMap[rowIndex+currRow][colIndex+currRow] for currRow in range(-min(rowIndex,colIndex),0)]
            leftUp = cleanList(leftUp)
            if leftUp:
                leftUp = leftUp[-1]

            rightDown = [seatMap[rowIndex+currRow][colIndex+currRow] for currRow in range(1,min(numRows+1-rowIndex, numCols+1-colIndex)+1)]
            rightDown = cleanList(rightDown)
            if rightDown:
                rightDown = rightDown[0]

            #(seatMap[rowIndex][colIndex], '->', toLeft,' ',toRight,' ',toTop,' ',toBot,' ',rightUp,' ',leftDown,' ',leftUp,' ',rightDown)
            numAdjFilled = ('#' in toLeft) + ('#' in toRight) + ('#' in toTop) + ('#' in toBot) + ('#' in rightUp) + ('#' in leftDown) + ('#' in leftUp) + ('#' in rightDown)

            if seatMap[rowIndex][colIndex] == 'L' and numAdjFilled == 0:
                newMap[rowIndex][colIndex] = '#'
            elif seatMap[rowIndex][colIndex] == '#' and numAdjFilled >= 5:
                newMap[rowIndex][colIndex] = 'L'

    fullList_seatMap = [''.join(seatRow) for seatRow in seatMap]
    fullList_newMap = [''.join(newRow) for newRow in newMap]
    if fullList_seatMap == fullList_newMap:
        break
    else:
        seatMap = newMap.copy()

numOccupied = 0
for rowIndex in range(1,numRows+1):
    numOccupied = numOccupied + seatMap[rowIndex].count('#')

print('Second half')
print('Number of occupied seats = ', numOccupied)
