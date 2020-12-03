import csv

# Define a function to check the sum of pairs from the input list and return the product
def checkSum(inputList, sumVal):
    while inputList:
            currVal = inputList.pop()
            resVal = sumVal - currVal
            if resVal in inputList:
                prodVal = currVal*resVal
                return currVal, resVal, prodVal
    return [], [], []
# create an empty array
inputList = []

# create a variable to store the sum
sumVal = 2020

# store the input in the array
with open('input.txt',newline='') as csvfile:
    inputReader = csv.reader(csvfile, delimiter= ' ', quotechar='|')
    for row in inputReader:
        for str in row:
            inputList.append(int(str))

# First half
currVal, resVal, prodVal = checkSum(inputList.copy(), sumVal)

print('first half')
if prodVal:
    print(currVal, resVal, prodVal)
else:
    print('pair doesn\'t exist')

# Second half
while inputList:
    firstVal = inputList.pop()
    secondSum = sumVal - firstVal
    currVal, resVal, prodVal = checkSum(inputList.copy(), secondSum)
    if prodVal:
        prodVal = prodVal*firstVal
        break

print('second half')
if prodVal:
    print(firstVal, currVal, resVal, prodVal)
else:
    print('triplet doesn\'t exist')
