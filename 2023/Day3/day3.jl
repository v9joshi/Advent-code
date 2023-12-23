inputs = read(".\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")     # Sanitize inputs
inputs = strip(inputs,'\n')           # Trailing end line is annoying

# Split the input into lines
inputLines = split.(inputs,'\n')

# Find the sum of valid engine part numbers
partsSum = 0

# Get all neighbours for a node in the engine diagram
function getNeighbours(startX, endX, coordY, maxX, maxY)
    allNeighbours = []
    for (i, j) = Iterators.product(startX-1:endX+1, coordY-1:coordY+1)
        if (i ≥ 1) && (i ≤ maxX) && (j ≥  1) &&  (j ≤ maxY)
            push!(allNeighbours,[i,j])
        end
    end

    return allNeighbours
end

# Find numbers in the input data for each line
for (lineNum, currLine) = enumerate(inputLines)
    pos = findall(r"(\d+)", currLine)

    # Check the neighbours for this number
    for currPos = pos
        # Get the neighbour
        neighbourList   = getNeighbours(currPos[1], currPos[end], lineNum, length(currLine), length(inputLines))
        neighbourString = map(x -> inputLines[x[2]][x[1]], neighbourList)

        # Check if any of the neighbours is a valid symbol
        if any(map(x -> !(isdigit(x) || (x == '.')), neighbourString))
            # If valid then add to the sum
            global partsSum = partsSum + parse(Int, currLine[currPos])
            print(currLine[currPos], " is valid \n")
        else
            print(currLine[currPos], " is not valid \n")
        end
    end
end

# What is the sum of the valid parts
print("Answer part #1 = ", partsSum, "\n")

# Part 2 time to build a dictionary
gearDict = Dict()

# Go through each line to find the stars
for (lineNum, currLine) = enumerate(inputLines)
    # Locate all the stars in the data
    starPos = findall("*", currLine)
    for currPos = starPos
        gearDict[[currPos[1], lineNum]] = []
    end
end

# Now find the numbers
for (lineNum, currLine) = enumerate(inputLines)
    pos = findall(r"(\d+)", currLine)
    for currPos = pos
        neighbourList   = getNeighbours(currPos[1], currPos[end], lineNum, length(currLine), length(inputLines))
        
        for neighbourPos in neighbourList
            if neighbourPos in keys(gearDict)
                append!(gearDict[neighbourPos], parse(Int, currLine[currPos]))
            end
        end

    end
end

gearSum = 0
# Now if there are only two gears in the value of any key for gear dict, multiply them then add them to the total
for gearPos in keys(gearDict)
    if length(gearDict[gearPos]) == 2
        global gearSum = gearSum + prod(gearDict[gearPos])
    end
end

print("Answer part #2 =", gearSum)



