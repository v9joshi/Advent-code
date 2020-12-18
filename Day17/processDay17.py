import csv
from math import floor
from itertools import starmap, product

def findAllNeighbours(pos):
    # Define a list of neighbours
    delNeighbour = starmap(lambda a,b,c: (pos[0]+a,pos[1]+b,pos[2]+c), product((0,-1,+1), (0,-1,+1),(0,-1,+1)))

    return list(delNeighbour)[1:]

def convert3dto1d(threeDimPos, numSlices, numRows, numCols):
    oneDimPos = threeDimPos[2]*numRows*numCols + threeDimPos[1]*numCols + threeDimPos[0]

    if oneDimPos < (numCols*numRows*numSlices):
        return oneDimPos
    else:
        return []

def convert1dto3d(oneDimPos, numSlices, numRows, numCols):
    zPos = floor(oneDimPos/(numRows*numCols))
    yPos = floor((oneDimPos - zPos*numRows*numCols)/numCols)
    xPos = oneDimPos  - zPos*numRows*numCols - yPos*numCols

    if (-1 < xPos < numCols) and (-1 < yPos < numRows) and (-1 < zPos < numSlices):
        return (xPos, yPos, zPos)
    else:
        return([],[],[])

def checkCondition(oneDimPos, conway3D, numSlices, numRows, numCols):
    threeDimPos = convert1dto3d(oneDimPos, numSlices, numRows, numCols)
    neighbour3DList = findAllNeighbours(threeDimPos)
    neighbour1DList = [convert3dto1d(currNeighbour, numSlices, numRows, numCols) for currNeighbour in neighbour3DList]
    neighbourVals = [conway3D[neighbour1DPos] for neighbour1DPos in neighbour1DList if neighbour1DPos in range(1, len(conway3D))]

    activeCount = neighbourVals.count('#')

    if activeCount == 3:
        return 1
    elif conway3D[oneDimPos] == '#' and activeCount == 2:
        return 1
    else:
        return 0

def print3D(conway3D, numSlices, numRows, numCols):
    for zPos in range(0, numSlices):
        print('sliceNum = ', zPos)
        for yPos in range(0, numRows):

            startPos = convert3dto1d((0,yPos,zPos), numSlices, numRows, numCols)
            print((0,yPos,zPos), ' = ', startPos)
            print(conway3D[startPos:startPos+numCols])

# create empty arrays
inputList = []

# store the input in the array
with open('input.txt',newline='') as csvfile:
    inputReader = csv.reader(csvfile, delimiter= '\n', quotechar='|')
    # store the input in the array
    for row in inputReader:
        row = list(row[0])
        inputList.append(row)

# Conways game of life in 3D
numSlices = 1 # Start with 1 slice
numRows = len(inputList[0]) # We already know the number of rows
numCols = len(inputList)    # and the number of columns

# initialize the list of elements
conway3D = []
for row in inputList:
    conway3D.extend(row)

print3D(conway3D, numSlices, numRows, numCols)
# Start the cycles
cycles = 0
while cycles < 6:
    cycles = cycles + 1

    # Find all the filled cells
    filledCells = []
    filledCells = [convert1dto3d(oneDimPos, numSlices, numRows, numCols) for oneDimPos, cellVal in enumerate(conway3D) if cellVal =='#']

    # Add more slices and rows and columns
    numSlices = numSlices + 2
    numRows = numRows + 2
    numCols = numCols + 2

    # Make a space with nothing filled
    conway3D = ['.']*numRows*numCols*numSlices

    # Refill the original spaces
    for threeDPos in filledCells:
        # Shift each coordinate by 1
        threeDPos = (threeDPos[0] + 1, threeDPos[1] + 1, threeDPos[2] + 1)
        oneDPos = convert3dto1d(threeDPos, numSlices, numRows, numCols)
        conway3D[oneDPos] = '#'

    # print3D(conway3D, numSlices, numRows, numCols)

    # Propogate some life
    conway3D = ['#' if checkCondition(currOneDPos, conway3D, numSlices, numRows, numCols) else '.' for currOneDPos in range(0, len(conway3D))]
    print3D(conway3D, numSlices, numRows, numCols)


numActive = conway3D.count('#')
print('Num active cells = ', numActive)
