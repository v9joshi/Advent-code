import csv

def codeToNum(seatCode):
    # parse the seat code
    rowCode = seatCode[0:7]
    # row values are stored as binary with F = 0, B = 1
    rowCode = rowCode.replace('F','0')
    rowCode = rowCode.replace('B','1')

    # Column values are stored as binary with L = 0, R = 1
    colCode = seatCode[7:10]
    colCode = colCode.replace('L','0')
    colCode = colCode.replace('R','1')

    # Convert the binary numbers into integers
    rowNum = int(rowCode,2)
    colNum = int(colCode,2)

    # return the seat number
    return rowNum*8 +colNum # We could also do this without splitting row and col

# create an empty array
inputList = []
# store the input in the array
with open('input.txt',newline='') as csvfile:
    inputReader = csv.reader(csvfile, delimiter= ' ', quotechar='|')
    for row in inputReader:
        inputList.append(row[0])

# create an empty list of seats
seatNum = []

# Find out all the seats numbers from the codes
for seatCode in inputList:
    seatNum.append(codeToNum(seatCode))

# First half
print('Highest seat number ', max(seatNum))

# Second half
# Create a list of all seats
allSeats = list(range(min(seatNum),max(seatNum),1))

# Find the missing seat using a set difference
missingSeats = list(set(allSeats)-set(seatNum))

# Print the missing seats
print('Unassigned seats: ', missingSeats)
