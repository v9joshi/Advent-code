import csv
import re

def checkValidity(inputDict):
    # years
    byr = inputDict['byr']
    byrPattern = re.compile("19[2-9][0-9]|200[0-2]")

    iyr = inputDict['iyr']
    iyrPattern = re.compile("201[0-9]|2020")

    eyr = inputDict['eyr']
    eyrPattern = re.compile("202[0-9]|2030")

    # height
    hgt = inputDict['hgt']
    hgtPattern = re.compile("59in|6[0-9]in|7[0-6]in|1[5-8][0-9]cm|19[0-3]cm")

    # hair/eye color
    hcl = inputDict['hcl']
    hclPattern = re.compile("#[0-9A-Fa-f]{6}")

    ecl = inputDict['ecl']
    eclPattern = re.compile("amb|blu|brn|gry|grn|hzl|oth")

    # passport id
    pid = inputDict['pid']
    pidPattern = re.compile("[0-9]{9}")

    # Check each of the fields for valid inputs
    if not byrPattern.fullmatch(byr):
        return 0

    if not iyrPattern.fullmatch(iyr):
        return 0

    if not eyrPattern.fullmatch(eyr):
        return 0

    if not hgtPattern.fullmatch(hgt):
        return 0

    if not hclPattern.fullmatch(hcl):
        return 0

    if not eclPattern.fullmatch(ecl):
        return 0

    if not pidPattern.fullmatch(pid):
        return 0

    return 1

# create an empty array
inputList = [[]]
# store the input in the array
with open('input.txt',newline='') as csvfile:
    inputReader = csv.reader(csvfile, delimiter= ' ', quotechar='|')
    for row in inputReader:
        if row:
            inputList[-1].extend(row)
        else:
            inputList.append([])

# initialize checking variables
numRight = 0
numWrong = 0

checkSet = set(['byr','iyr','eyr','hgt','hcl','ecl','pid'])
# now check each entry
dictList = []
for currPass in inputList:
    # check each value in each entry
    currDict = {currVal.split(':')[0]:currVal.split(':')[1] for currVal in currPass}
    dictList.append(currDict)
    if checkSet.issubset(currDict):
        if checkValidity(currDict):
            numRight = numRight + 1
        else:
            numWrong = numWrong + 1
    else:
        #print('Invalid', currDict)
        numWrong = numWrong + 1

print(numRight, ' valid passports, and ', numWrong,' invalid passports')
