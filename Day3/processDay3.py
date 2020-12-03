import csv

def howManyTrees(inputList, travRight, travDown):
    # What is the starting position
    currX = 0
    currY = 0

    # How many trees have been encountered?
    numTrees = 0

    # Parse the input to find the number of trees
    while currY < len(inputList):
        currRow = list(inputList[currY][0])
        if currRow[currX] == '#':
            numTrees = numTrees + 1
            currRow[currX] = 'X'
        else:
            currRow[currX] = 'O'

        print("".join(currRow))

        # Iterate to the next position on the map
        currY = currY + travDown
        currX = currX + travRight

        # Check overflow
        if currX >= len(currRow):
            currX = currX - len(currRow)

    return numTrees


# create an empty array
inputList = []

# store the input in the array
with open('input.txt',newline='\n') as csvfile:
    inputReader = csv.reader(csvfile, delimiter= ' ', quotechar='|')
    for row in inputReader:
        inputList.append(row)

# How much are we traversing by
result1 = howManyTrees(inputList, 1, 1)
result2 = howManyTrees(inputList, 3, 1)
result3 = howManyTrees(inputList, 5, 1)
result4 = howManyTrees(inputList, 7, 1)
result5 = howManyTrees(inputList, 1, 2)

print(result1*result2*result3*result4*result5)
