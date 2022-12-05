import csv

# create empty arrays
inputList = []

# store the input in the array
with open('input.txt',newline='') as csvfile:
    inputReader = csv.reader(csvfile, delimiter= ' ', quotechar='|')
    # store the input in the array
    for row in inputReader:
        inputList.append(row[0])

# Find the start time
startTime = int(inputList.pop(0))

# Turn the bus number input string into a list
inputList = ''.join(inputList).split(',')

# First half
# Find the bus numbers that are not x
busList = [int(bus) for bus in inputList if not bus == 'x']

# How long do we have to wait for the bus?
# i.e. find the the difference between the current time and the closest higher
# multiple of the bus number
busWaitTime = [bus - startTime%bus for bus in busList]

# We have to return the product of busNum*waitTime for the bus with the smallest
# wait time.
minBusProd = [busNum*busTime for busNum, busTime in zip(busList, busWaitTime) if busTime == min(busWaitTime)]

print('Bus number x wait time for the earliest available bus is ', minBusProd)

# Second half
# The question setter is kind and has given us coprime bus numbers so this is
# solved using the "Chinese remainder theorem"
busList = [(int(bus), (int(bus) - waitTime)%int(bus)) for waitTime, bus in enumerate(inputList) if not bus == 'x']

# We need to sort the bus list based on bus number
def getKey(item):
    return min(item)

busList = sorted(busList, key = getKey)#, reverse = True)

print(busList)

# Now we need to find the number t such that t%busNum = waitTime for all buses

tVal = 0
stepVal = 1

for busPair in busList:

    while not (tVal%busPair[0] == busPair[1]):
        tVal = tVal + stepVal
    stepVal = stepVal*busPair[0]
    print(tVal, stepVal)

print('min value of t is ', tVal)
