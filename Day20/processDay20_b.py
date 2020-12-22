import re
from itertools import combinations, product
import math

# Function to rotate an image tile
def rotateTile(tileImage, transNum):
    newTile = []
    # Flip
    if transNum == -1:
        for rowNum, row in enumerate(tileImage):
            tileImage[rowNum] = row[::-1]

    # turn clockwise 1 time
    elif transNum == 1:
        tempImage = [list(row) for row in tileImage]
        tileImage = [''.join(rowVal) for rowVal in zip(*tempImage[::-1])]

    return tileImage

# Function to find the edges for a given image tile
def findEdges(tileImage):
    # Convert strings into lists to split them
    tileImage = [list(row) for row in tileImage]
    #print(tileImage)
    # Find the four edges for this image
    allEdges = []
    for tileOrientation in range(4):
        # find top edge
        allEdges.append(''.join(pixel for pixel in tileImage[0]))
        # rotate tile
        tileImage = rotateTile(tileImage,1)

    # Return the list of edges for the current image tile
    return allEdges

# Strip the edges from the image tile
def imageStrip(tileImage):
    # Convert strings into lists to split them
    tileImage = [list(row) for row in tileImage]

    # Remove the edges
    cleanImage = [''.join(row[1:-1]) for row in tileImage[1:-1]]
    return cleanImage

# Read the data
f = open('input.txt')
raw = f.read()
raw = raw.replace('.','1')
raw = raw.replace('#','0')
tileBlocks = raw.split('\n\n')

# Store the tiles in a dict
imageDict = {}
freeEdges = {}
edgeConnections = {}
for tile in tileBlocks:
    #print(tile)
    # Find the name of the tile and the corresponding image
    tileName, tileImage = tile.split(':')
    tileName = tileName.split(' ')[1]
    tileImage = [row for row in tileImage.splitlines() if row]

    tileName = int(tileName)

    imageDict[tileName] = tileImage

    # For each tile, make a dict of freeEdges and edgeConnections
    freeEdges[tileName] = set([0,1,2,3])
    edgeConnections[tileName] = {}

# Create a set of locked tiles
lockedTiles = set()
# Lock any tile to start with
lockedTiles.add(tileName)

# Keep going till all tiles are locked
while len(lockedTiles) < len(imageDict.keys()):
    # Check each locked tile with each unlocked tile
    for tile1, tile2 in product(lockedTiles, set(imageDict.keys()) - lockedTiles):
        # Find the edges for the selected tiles
        tile1Edges = findEdges(imageDict[tile1])
        tile2Edges = findEdges(imageDict[tile2])

        # Compare the free edges for both selected tiles
        for edge1, edge2 in product(freeEdges[tile1], freeEdges[tile2]):
            # Edges 1 should match the reverse of edge 2 for a correct fit
            if tile1Edges[edge1] == tile2Edges[edge2][::-1]:
                # If the edges are connected incorrectly rotate
                if not abs(edge1 - edge2) == 2: # 0 connects to 2, 1 connects to 3
                    # turn it
                    imageDict[tile2] = rotateTile(imageDict[tile2],1)
                # Otherwise the tile is oriented correctly
                else:
                    # Mark edges as occupied
                    freeEdges[tile1].remove(edge1)
                    freeEdges[tile2].remove(edge2)

                    # Store the connections
                    edgeConnections[tile1][edge1] = tile2
                    edgeConnections[tile2][edge2] = tile1

                    # Lock the tile
                    lockedTiles.add(tile2)
                # No need to check the other edges
                break

            # If we need to flip the tile:
            elif tile1Edges[edge1] == tile2Edges[edge2]:
                # flip it and we'll find it in the next pass
                imageDict[tile2] = rotateTile(imageDict[tile2],-1)
                # No need to check the other edges
                break

# Run the connection routine again till everything has at least 2 connections
# Leave everything locked
for tile1, tile2 in combinations(lockedTiles, 2):
    # Find the edges for the selected tiles
    tile1Edges = findEdges(imageDict[tile1])
    tile2Edges = findEdges(imageDict[tile2])

    # Compare the free edges for both selected tiles
    for edge1, edge2 in product(freeEdges[tile1], freeEdges[tile2]):
        if tile1Edges[edge1] == tile2Edges[edge2][::-1]:
            # If the edges are connected incorrectly rotate
            if abs(edge1 - edge2) == 2: # 0 connects to 2, 1 connects to 3
                # Mark edges as occupied
                freeEdges[tile1].remove(edge1)
                freeEdges[tile2].remove(edge2)

                # Store the connections
                edgeConnections[tile1][edge1] = tile2
                edgeConnections[tile2][edge2] = tile1
            break

#print(*zip(edgeConnections.keys(), edgeConnections.values()),sep = '\n')

# First half
print('First half')
edgeProd = 1
for tile in imageDict.keys():
    if len(freeEdges[tile]) == 2:
        edgeProd = edgeProd*tile

print('Edge product = ', edgeProd)

# Second half
# Generate the tile mosaic:
gridSize = int(math.sqrt(len(lockedTiles)))
imageGrid = []
imageGrid = [[0]*gridSize for i in range(gridSize)]
tileGrid = [[0]*gridSize for i in range(gridSize)]
usedTiles = set()
# print(gridSize)

# print(imageGrid)
# Fill the grid
for rowNum in range(gridSize):
    # print(rowNum)
    # Look through all the locked tiles
    for tile in lockedTiles:
        # If the top left edge is free this is the top left corner tile
        if {0,1}.issubset(freeEdges[tile]):
            # Build the row for this tile
            for colNum in range(gridSize):
                # print('matched')
                # print(edgeConnections[tile])
                imageGrid[rowNum][colNum] = imageStrip(imageDict[tile].copy())
                tileGrid[rowNum][colNum] = tile

                # delete this tile from locked tiles list
                lockedTiles.remove(tile)

                # Free the selected tile from the group
                if 2 in edgeConnections[tile].keys():
                    freeEdges[edgeConnections[tile][2]].add(0)

                if 3 in edgeConnections[tile].keys():
                    freeEdges[edgeConnections[tile][3]].add(1)
                    tile = edgeConnections[tile][3]

            break

# print(*tileGrid, sep='\n')
# Find the full image
joinedImage = []
for gridRow in imageGrid:
    correctedImage = [''.join(row) for row in zip(*gridRow)]
    joinedImage.extend(correctedImage)

# Second half
seaMonster = ['..................#.',
              '#....##....##....###',
              '.#..#..#..#..#..#...']

# Testing use only
#seaMonster = ['111111111111111011111110111011101111111111101111110000110111110111101101111',
#'101111111111111100110011111111111011011111111010111111101001110111101010111',
#'111011111111011111110111111111100111100011001101101110111101111110110111111',
#'111101101101100001011101111111110011001011110110111111111110011110001110110',
#'011101110110111011011011111111100011111111011101101111111111111100111111110']
# Testing end

monsterHeight = len(seaMonster)
monsterLength = len(seaMonster[0])

seaMonster = ''.join(seaMonster)
# Testing use only
#seaMonster = seaMonster.replace('0','#')
#seaMonster = seaMonster.replace('1','.')
# Testing end

seaMonster = seaMonster.replace('.','0')
seaMonster = seaMonster.replace('#','1')

for i in range(0,8):
    print(i)
    if i == 4:
        # Return to norma
        joinedImage = rotateTile(joinedImage, 1)
        # Flip horizontal
        joinedImage = rotateTile(joinedImage, -1)
    else:
        joinedImage = rotateTile(joinedImage, 1)

    # How many hashes are there in the image?
    fullImage = ''.join(joinedImage)
    numHashes = fullImage.count('0')
    monsterHashes = seaMonster.count('1')
    nonMonsterHashes = numHashes

    #print(len(joinedImage))
    #print(len(joinedImage[0]))

    # Search for the monster in each sub-image of the main image
    for startRow in range(len(joinedImage)-monsterHeight+1):
        for startCol in range(len(joinedImage[0])-monsterLength+1):
            #print(startRow, startCol)
            # Build the sub-image
            subImage = [imageRow[startCol:(startCol+monsterLength)] for imageRow in joinedImage[startRow:(startRow+monsterHeight)]]
            subImage = ''.join(subImage)

            if not (int(subImage,2) & int(seaMonster,2)):
                print('Monster detected')
                nonMonsterHashes = nonMonsterHashes - monsterHashes
                #print(seaMonster)
                #print(subImage)
                #print('\n\n')

    print('Non monster hashes = ', nonMonsterHashes)

#print(*tileGrid, sep = '\n')
joinedImage = rotateTile(joinedImage,1)
joinedImage = rotateTile(joinedImage,1)
#print(*joinedImage, sep = '\n')

#print(len(imageDict.keys()))
