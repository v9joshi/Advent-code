import re
from itertools import combinations, product

f = open('testInput.txt')
raw = f.read()
raw = raw.replace('.','1')
raw = raw.replace('#','0')
tileBlocks = raw.split('\n\n')

# Store the tiles in a dict
imageDict = {}
for tile in tileBlocks:
    #print(tile)
    tileName, tileImage = tile.split(':')
    tileName = tileName.split(' ')[1]
    tileImage = [row for row in tileImage.splitlines() if row]

    imageDict[tileName] = tileImage

# Program to find the edges for a given image tile
def findEdges(tileImage):
    # Convert strings into lists to split them
    tileImage = [list(row) for row in tileImage]
    #print(tileImage)
    # Find the four edges for this image
    allEdges = []
    allEdges.append(''.join(pixel for pixel in tileImage[0]))   # Top Row
    allEdges.append(''.join(row[0] for row in tileImage[::-1])) # Left edge
    allEdges.append(''.join(pixel for pixel in tileImage[-1][::-1]))  # Bottom row
    allEdges.append(''.join(row[-1] for row in tileImage))      # Right edge

    # Return the list of edges for the current image tile
    return allEdges

# Create a dict of all the edges
edgesDict = {}
connectionsDict = {}

for key in imageDict.keys():
    edgesDict[key] = findEdges(imageDict[key])

# print(edgesDict)
connectionMap = []
for tile1, tile2 in combinations(edgesDict.keys(),2):
    #print(tile1, tile2)
    for tile1Edge, tile2Edge in product(range(4),repeat = 2):
        #print(tile1Edge, tile2Edge)
        #print(edgesDict[tile1][tile1Edge], edgesDict[tile2][tile2Edge])
        if edgesDict[tile1][tile1Edge] == edgesDict[tile2][tile2Edge]:
            #print(tile1Edge, tile2Edge, ' match')
            connectionMap.append(tile1+' '+str(tile1Edge+1)+':'+str(tile2Edge+1)+' '+tile2)
            connectionsDict[tile1+'_'+str(tile1Edge+1)] = tile2+'_'+str(tile2Edge+1)
            connectionsDict[tile2+'_'+str(tile2Edge+1)] = tile1+'_'+str(tile1Edge+1)
        # If we need to flip the tile:
        elif edgesDict[tile1][tile1Edge] == edgesDict[tile2][tile2Edge][::-1]:
            #print(tile1Edge, tile2Edge, '_reverse match')
            connectionMap.append(tile1+' '+str(tile1Edge+1)+':'+str(-(tile2Edge+1))+' '+tile2)
            connectionsDict[tile1+'_'+str(tile1Edge+1)] = tile2+'_'+str(-(tile2Edge+1))
            connectionsDict[tile2+'_'+str(-(tile2Edge+1))] = tile1+'_'+str(tile1Edge+1)

# First half
connectionKeys = [keyVal for keyVal in connectionsDict.keys()]
connectionFreq = [tileNum for tileNum, connectionKey in product(imageDict.keys(), connectionsDict.keys()) if tileNum in connectionKey or tileNum in connectionsDict[connectionKey]]

edgeTiles = [int(tileNum) for tileNum in imageDict.keys() if connectionFreq.count(tileNum) == 4]
print(edgeTiles)

print('first half')
print('product of edge tiles: ', edgeTiles[0]*edgeTiles[1]*edgeTiles[2]*edgeTiles[3])
