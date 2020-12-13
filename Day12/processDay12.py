import csv
import math

class Ship:
    def __init__(self, pos, dir):
        self.currPos = pos
        self.currDir = dir

        self.directions = {
            'N': (1,0),
            'S': (-1,0),
            'E': (0,1),
            'W': (0,-1),
            'F': self.currDir
        }

    def turn(self, turnDir, turnAng):
        # Left turn = -ve angle right turn
        if turnDir == 'L':
            turnAng = -turnAng

        # Rotation transform
        radArg = math.radians(turnAng)
        cosArg = math.cos(radArg)
        sinArg = math.sin(radArg)
        self.currDir = (self.currDir[0]*cosArg - self.currDir[1]*sinArg, self.currDir[0]*sinArg + self.currDir[1]*cosArg)
        self.directions['F'] = self.currDir

    def move(self, movDir, movArg):
        self.currPos = (self.currPos[0] + self.directions[movDir][0]*movArg, self.currPos[1] + self.directions[movDir][1]*movArg)

    def moveWP(self, movDir, movArg):
        self.currDir = (self.currDir[0] + self.directions[movDir][0]*movArg, self.currDir[1] + self.directions[movDir][1]*movArg)
        self.directions['F'] = self.currDir


    def action(self, command, argument):
        if command in ('L','R'):
            self.turn(command, argument)
        elif command in ('N','S','E','W','F'):
            self.move(command, argument)
        else:
            print('Unexpected command')

    def actionWP(self, command, argument):
        if command in ('L','R'):
            self.turn(command, argument)
        elif command in ('F'):
            self.move(command, argument)
        elif command in ('N','E','W','S'):
            self.moveWP(command, argument)
        else:
            print('Unexpected command')

    def manhattanDist(self):
        return abs(self.currPos[0]) + abs(self.currPos[1])

# create an empty array
commandList = []
argumentList = []

# store the input in the array
with open('input.txt',newline='') as csvfile:
    inputReader = csv.reader(csvfile, delimiter= ' ', quotechar='|')
    # store the input in the array
    for row in inputReader:
        if row:
            # Store the list of rules
            commandList.append(row[0][0])
            argumentList.append(int(row[0][1:]))

# First half
# Ship starts at origin and facing east
ship = Ship((0,0),(0,1))

for command, argument in zip(commandList, argumentList):
    ship.action(command, argument)
    print(ship.currPos, ship.currDir)

print('First half')
print('Manhattan distance : ',ship.manhattanDist())

# Second half
# Ship starts at origin and way point is at N:1, E:10
ship = Ship((0,0),(1,10))

for command, argument in zip(commandList, argumentList):
    ship.actionWP(command, argument)
    print(ship.currPos, ship.currDir)

print('Second half')
print('Manhattan distance : ',ship.manhattanDist())
