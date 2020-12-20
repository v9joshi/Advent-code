import csv
import re

# create empty arrays
inputList = []

# store the input in the array
with open('input.txt',newline='') as csvfile:
    inputReader = csv.reader(csvfile, delimiter= '\n', quotechar='|')
    # store the input in the array
    for row in inputReader:
        row = row
        if row:
            inputList.append(row[0])
        else:
            inputList.append([])

rulesList = []

while inputList[0]:
    rulesList.append(inputList.pop(0))

# Make a dict of rules
rulesDict = {}

#while rulesList:
while '0' not in rulesDict.keys():
    for ruleNum, currRule in enumerate(rulesList):
        currRule = currRule.split(':')
        if not currRule[0] in rulesDict.keys():
            # If there are no numbers, store in dict
            if not re.findall('\d',currRule[1]):
                newRule = [currChar for currChar in currRule[1] if (currChar.isalpha() or currChar in '()|%')]
                newRule = ''.join(newRule)
                rulesDict[currRule[0]] = newRule
            else:
            # if there are numbers replace numbers with corresponding dict
                currRule[1] = currRule[1].split(' ')

                for subNum, subRule in enumerate(currRule[1]):
                    if subRule in rulesDict.keys():
                        currRule[1][subNum] = '(' + subRule.replace(subRule, rulesDict[subRule]) + ')'

                currRule[1] = ' '.join(currRule[1])
                rulesList[ruleNum] = currRule[0]+':'+currRule[1]

matchCheck = []
for input in inputList:
    if input:
        if re.fullmatch(rulesDict['0'],input):
            matchCheck.append(1)
        else:
            matchCheck.append(0)

print('first half')
print('num matches to rule 0: ', sum(matchCheck))

# Second half
matchCheck = []
for input in inputList:
    if input:
        for i in range(1,len(input)):
            specialRule = '(('+rulesDict['42']+')+)' + '((' + rulesDict['42'] +'){'+str(i)+'})' + '(('+rulesDict['31']+'){'+str(i)+'})'
            if re.fullmatch(specialRule,input):
                matchCheck.append(1)
                break
            else:
                matchCheck.append(0)

print('second half')
print('num matches to rule 0: ', sum(matchCheck))
