# Read the data
f = open('input.txt')
# f = open('testInput.txt')

raw = f.read()
keys = raw.splitlines()
keys = [int(key) for key in keys]

print(keys)

remVal   = 20201227
startNum = 1
subjVal  = 7
loopVal = 0

while 1:

    loopVal = loopVal + 1

    startNum = startNum*subjVal
    startNum = startNum % remVal

    if startNum == keys[0]:
        subjVal2 = keys[1]
        break
    elif startNum == keys[1]:
        subjVal2 = keys[0]
        break

print(loopVal)

startNum = 1

for i in range(loopVal):
    startNum = startNum*subjVal2
    startNum = startNum % remVal

print("Final key = ", startNum)
