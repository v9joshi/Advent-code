# Read the data
f = open('input.txt')
# f = open('testInput.txt')

raw = f.read()
tileBlocks = raw.split('\n')

# Function to find how much to move by
def findMove(tile):
    char = tile.pop(0)

    # Check direction
    if char in 'ew':
        return [-1.0,0.0] if char == 'w' else [1.0,0.0]

    # diagonal moves are only half moves
    if char in 'sn':
        sideMove = 0.5*findMove(tile)[0]
        return [sideMove, 0.5] if char == 'n' else [sideMove, -0.5]

def findNeighbours(tileCoords):
    # List the neighbour directions
    neighbourCoords = []
    neighbourList = ['e','w','se','sw','ne','nw']

    # For each direction find the coordinates
    for neighbour in neighbourList:
        neighbour = list(neighbour)
        currNeighbour = [currCoord + moveCoord for currCoord, moveCoord in zip(tileCoords, findMove(neighbour))]
        neighbourCoords.append(currNeighbour)

    return neighbourCoords

# Make a list of black tiles
blackTiles = []

# Flip the tiles for the first time
for tile in tileBlocks:
    # Account for empty strings
    if not tile:
        continue

    # Coordinates of the tiles
    tileCoords = [0,0]
    # print(tile,':')
    tile = list(tile)

    # Find the coordinates for the tile
    while tile:
        move = findMove(tile)
        tileCoords = [currCoord+moveCoord for currCoord, moveCoord in zip(tileCoords, move)]
    #print(tileCoords)

    # Flip the tile
    if tileCoords in blackTiles:
        # print('already black, turn white')
        blackTiles.remove(tileCoords)
    else:
        # print('tile is now black')
        blackTiles.append(tileCoords)

    # print(blackTiles)

print('First half')
print('Num black tiles = ', len(blackTiles))

# Second half
numDays = 100

# Do the tile update for each day
for currDay in range(numDays):
    # Make a list of all the tiles and their neighbours with repetition
    allTiles = []

    # Make a list of tiles to turn black and tiles to turn white
    removeList = []
    addList = []

    # Find all the tiles with black tile neighbours
    for currTile in blackTiles:
        allNeighbours = findNeighbours(currTile)
        # print(allNeighbours)
        allTiles.extend(allNeighbours)

    # For each tile, find if it should be:
    # 1. flipped to white
    for tile in blackTiles:
        # Count the number of neigbouring black tiles
        repCount = allTiles.count(tile)

        # If there are none or too many, flip the tile
        if (tile in blackTiles) and (repCount == 0 or repCount > 2):
            removeList.append(tile)

        while tile in allTiles:
            allTiles.remove(tile)

    # 2. flipped to black
    while allTiles:
        # Select a tile
        tile = allTiles[0]
        # print(tile)
        # Count the number of neigbouring black tiles
        repCount = allTiles.count(tile)

        # check the rules
        if (tile not in blackTiles) and repCount == 2:
            addList.append(tile)

        while tile in allTiles:
            allTiles.remove(tile)

    # print(blackTiles)
    # Add the tiles that flip to black
    for newBlackTile in addList:
        # print('add', newBlackTile)
        neighbouringBlackTiles = [tile for tile in findNeighbours(newBlackTile) if tile in blackTiles]
        # print('Neighbours:', neighbouringBlackTiles)
        blackTiles.append(newBlackTile)

    # Remove the tiles that flip to white
    for newWhiteTile in removeList:
        # print('remove', newWhiteTile)
        neighbouringBlackTiles = [tile for tile in findNeighbours(newWhiteTile) if (tile in blackTiles) and (tile not in addList)]
        blackTiles.remove(newWhiteTile)

    print('Num black tiles on day', currDay+1, ' = ', len(blackTiles))
