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

# Keep running the rules parser till rule 0 is solved
while '0' not in rulesDict.keys():
    # Go through all the rules
    for ruleNum, currRule in enumerate(rulesList):
        # Split the rule into a rule number and the rule info
        currRule = currRule.split(':')

        # If the rule has already been parsed skip it
        if not currRule[0] in rulesDict.keys():

            # If there are no numbers, store the rule in a dict
            if not re.findall('\d',currRule[1]):
                # If there are no numbers clean the rule and store in dict
                newRule = [currChar for currChar in currRule[1] if (currChar.isalpha() or currChar in '()|')]
                newRule = ''.join(newRule)
                # Dict storage
                rulesDict[currRule[0]] = newRule

            # If there are numbers, replace the numbers with their values from dict
            else:
                # Split at spaces to account for multi-digit numbers
                currRule[1] = currRule[1].split(' ')

                # For each multidigit number, replace with corresponding rule
                for subNum, subRule in enumerate(currRule[1]):
                    if subRule in rulesDict.keys():
                        currRule[1][subNum] = '(' + subRule.replace(subRule, rulesDict[subRule]) + ')'

                # Join the subrules to reform the rule
                currRule[1] = ' '.join(currRule[1])

                # Re-connect the rule number and the rule info
                rulesList[ruleNum] = currRule[0]+':'+currRule[1]

# Create a list of all inputs that match the selected rule
matchCheck = []

# Go through all the inputs
for input in inputList:
    # If the input exists check rule 0
    if input:
        # On match mark as 1
        if re.fullmatch(rulesDict['0'],input):
            matchCheck.append(1)
        # If match fails, mark as 0
        else:
            matchCheck.append(0)

# Find how many inputs match the rule
print('first half')
print('num matches to rule 0: ', sum(matchCheck))

# Second half
# Create a list of all inputs that match the selected rule
matchCheck = []
# Go through all the inputs
for input in inputList:
    # For non-empty inputs check the rules
    if input:
        # Here we make a custom rule for the 2nd half
        for i in range(1,len(input)):
            specialRule = '(('+rulesDict['42']+')+)' + '((' + rulesDict['42'] +'){'+str(i)+'})' + '(('+rulesDict['31']+'){'+str(i)+'})'

            # Check the rule, store 1 for match, 0 for fail
            if re.fullmatch(specialRule,input):
                matchCheck.append(1)
                break
            else:
                matchCheck.append(0)

# Find how many inputs match the rule
print('second half')
print('num matches to rule 0: ', sum(matchCheck))
