import csv

def codeToNum(seatCode):
    rowCode = seatCode[0:7]
    rowCode = rowCode.replace('F','0')
    rowCode = rowCode.replace('B','1')

    colCode = seatCode[7:10]
    colCode = colCode.replace('L','0')
    colCode = colCode.replace('R','1')

    rowNum = int(rowCode,2)
    colNum = int(colCode,2)

    #return [rowCode, colCode]
    return rowNum*8 +colNum

# create an empty array
inputList = []
# store the input in the array
with open('input.txt',newline='') as csvfile:
    inputReader = csv.reader(csvfile, delimiter= ' ', quotechar='|')
    for row in inputReader:
        inputList.append(row[0])

seatNum = []

for seatCode in inputList:
    seatNum.append(codeToNum(seatCode))

allSeats = list(range(min(seatNum),max(seatNum),1))
missingSeats = list(set(allSeats)-set(seatNum))

print(missingSeats)
