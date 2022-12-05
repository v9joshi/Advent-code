import csv
from math import floor
from itertools import starmap, product

# Find all the neighbours for a given 4d coordinate
def findAllNeighbours(pos):
    # Define a list of neighbours
    delNeighbour = starmap(lambda a,b,c,d: (pos[0]+a,pos[1]+b,pos[2]+c,pos[3]+d), product((0,-1,+1), repeat = 4))

    # Return the list
    return list(delNeighbour)[1:]

# Convert a 4d coordinate to a 1d coordinate
def convert4dto1d(threeDimPos, numCubes, numSlices, numRows, numCols):
    oneDimPos = threeDimPos[3]*numSlices*numRows*numCols + threeDimPos[2]*numRows*numCols + threeDimPos[1]*numCols + threeDimPos[0]

    # Make sure the 1d coordinate is valid, if yes return it
    if oneDimPos < (numCols*numRows*numSlices*numCubes):
        return oneDimPos
    # If invalid return an empty list
    else:
        return []

# Convert a 1d coordinate to a 4d coordinate
def convert1dto4d(oneDimPos, numCubes, numSlices, numRows, numCols):
    wPos = floor(oneDimPos/(numSlices*numRows*numCols))
    zPos = floor((oneDimPos - wPos*numSlices*numRows*numCols)/(numRows*numCols))
    yPos = floor((oneDimPos - wPos*numSlices*numRows*numCols - zPos*numRows*numCols)/numCols)
    xPos = oneDimPos  - wPos*numSlices*numRows*numCols - zPos*numRows*numCols - yPos*numCols

    # Make sure the coordinate is valid, if yes return it
    if (-1 < xPos < numCols) and (-1 < yPos < numRows) and (-1 < zPos < numSlices) and (-1 < wPos < numCubes):
        return (xPos, yPos, zPos, wPos)
    # If it isn't return empty coordinates
    else:
        return([],[],[],[])

# Check the required condition for staying alive/coming to life
def checkCondition(oneDimPos, conway4D, numCubes, numSlices, numRows, numCols):
    # Find the 4d position
    fourDimPos = convert1dto4d(oneDimPos, numCubes, numSlices, numRows, numCols)
    # Find all neighbours
    neighbour4DList = findAllNeighbours(fourDimPos)
    # Find 1d pos of neighbours
    neighbour1DList = [convert4dto1d(currNeighbour, numCubes, numSlices, numRows, numCols) for currNeighbour in neighbour4DList]
    # Find the values at those 1d positions
    neighbourVals = [conway4D[neighbour1DPos] for neighbour1DPos in neighbour1DList if neighbour1DPos in range(1, len(conway4D))]

    # How many neighbours are active
    activeCount = neighbourVals.count('#')

    # Use the rule to determine if cell should live or die
    if activeCount == 3:
        return 1
    elif conway4D[oneDimPos] == '#' and activeCount == 2:
        return 1
    else:
        return 0

# Printing the 4d universe
def print4D(conway4D, numCubes, numSlices, numRows, numCols):
    # Loop trough all cubes in the hypercube
    for wPos in range(0, numCubes):
        print('cubeNum = ', wPos)
        # Loop through all slices/planes in a cube
        for zPos in range(0, numSlices):
            print('sliceNum = ', zPos)
            # Loop through all rows in a slice/plane
            for yPos in range(0, numRows):

                # Start at the first column
                startPos = convert4dto1d((0,yPos,zPos,wPos), numCubes, numSlices, numRows, numCols)

                #Print the row
                print((0,yPos,zPos,wPos), ' = ', startPos)
                print(conway4D[startPos:startPos+numCols])

# create empty arrays
inputList = []

# store the input in the array
with open('input.txt',newline='') as csvfile:
    inputReader = csv.reader(csvfile, delimiter= '\n', quotechar='|')
    # store the input in the array
    for row in inputReader:
        row = list(row[0])
        inputList.append(row)

# Conways game of life in 4D
numCubes = 1 # Start with 1 cube
numSlices = 1 # Start with 1 slice
numRows = len(inputList[0]) # We already know the number of rows
numCols = len(inputList)    # and the number of columns

# initialize the list of elements
conway4D = []
for row in inputList:
    conway4D.extend(row)

print4D(conway4D, numCubes, numSlices, numRows, numCols)
# Start the cycles
cycles = 0
while cycles < 6:
    cycles = cycles + 1

    # Find all the filled cells
    filledCells = []
    filledCells = [convert1dto4d(oneDimPos, numCubes, numSlices, numRows, numCols) for oneDimPos, cellVal in enumerate(conway4D) if cellVal =='#']

    # Add more slices and rows and columns
    numCubes = numCubes + 2
    numSlices = numSlices + 2
    numRows = numRows + 2
    numCols = numCols + 2

    # Make a space with nothing filled
    conway4D = ['.']*numRows*numCols*numSlices*numCubes

    # Refill the original spaces
    for fourDPos in filledCells:
        # Shift each coordinate by 1
        fourDPos = (fourDPos[0] + 1, fourDPos[1] + 1, fourDPos[2] + 1, fourDPos[3] + 1)
        oneDPos = convert4dto1d(fourDPos, numCubes, numSlices, numRows, numCols)
        conway4D[oneDPos] = '#'

    # print4D(conway4D, numCubes, numSlices, numRows, numCols)

    # Propogate some life
    conway4D = ['#' if checkCondition(currOneDPos, conway4D, numCubes, numSlices, numRows, numCols) else '.' for currOneDPos in range(0, len(conway4D))]
    print4D(conway4D, numCubes, numSlices, numRows, numCols)


numActive = conway4D.count('#')
print('Num active cells = ', numActive)
