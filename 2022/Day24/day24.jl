# Read inputs
inputs = read(".\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")     # Sanitize inputs
inputs = strip(inputs,'\n')           # Trailing end line is annoying
inputs = split(inputs,"\n")           # Split into lines

# Parse the input
# Find the bounds of the map
maxX = length(split(inputs[1],""))
maxY = length(inputs)

println("max: $maxX,$maxY")

# Make sets of all blizzards
windHist = Dict()
windMap  = Dict()
windMap[">"] = Set()
windMap["<"] = Set()
windMap["^"] = Set()
windMap["v"] = Set()
windMap["#"] = Set()

for (rowNum, line) in enumerate(inputs)
    # Add all the blizzards
    for dirn in split(">^v<#","")
        for colNum in findall(contains(dirn), split(line,""))
            push!(windMap[dirn],CartesianIndex(colNum, rowNum))
        end
    end
end

# Store the initial map as that of t = 0
windHist[0] = windMap

# Make a movement dictionary
moveDict = Dict(">" => CartesianIndex(1,0,1),"<" => CartesianIndex(-1,0,1),
                "^" => CartesianIndex(0,-1,1),"v" => CartesianIndex(0,1,1),
                "#" => CartesianIndex(0,0,1))

# Make support 
# Display the map
function displayBlizz(windMap, maxX, maxY)
    # Make a list of all the blizzards
    allBlizz = Set()
    for windSet in values(windMap)
        allBlizz = allBlizz ∪ windSet
    end

    # Find the step number
    stepNum = maximum(allBlizz)[3]

    # Make a dot map
    for j = 1:maxY
        a = ""
        for i = 1:maxX
            a = (CartesianIndex(i,j, stepNum) in allBlizz) ? (a*'#') : (a*'.')
        end
        # Print the current line
        println(a)
    end
end

# Find neighbours
function allNeighbours(currPos, windMap, maxX, maxY)
    # Make an empty list to store neighbours
    neighboursList = []

    # Make a list of all the blizzards
    allBlizz = Set()
    for windSet in values(windMap)
        allBlizz = allBlizz ∪ windSet
    end

    # Check all possible moves
    for move in values(moveDict)
        newPos    = currPos + move

        # Check if new node is within terrain bounds
        validPos = false
        if maxX ≥ newPos[1] > 0 && maxY ≥ newPos[2] > 0
            validPos = true
        end

        if validPos
            # Check if new node can be visited
            if CartesianIndex(newPos[1], newPos[2]) in allBlizz
                # println(newNodeVal, " is illegal")
                push!(neighboursList, (newPos, false))
            else
                push!(neighboursList, (newPos, true))
                # println(newNodeVal, " is legal")
            end
        end
    end

    # Return all the neighbours
    return neighboursList
end

# Update the map for one step
function updateBlizzard(windMap, maxX, maxY)
    # Update the blizzards moving in each direction one at a time
    for dirn in keys(windMap)
        newWind = Set()

        # For each blizzard in the set, move it in the desired direction
        for blizz in windMap[dirn]
            # Move
            newBlizz = blizz + CartesianIndex(moveDict[dirn][1], moveDict[dirn][2])

            # Check bounds and wrap movement
            if dirn == "#"
                # solid boundaries don't wrap
            elseif newBlizz[1] ≤ 1 
                newBlizz = CartesianIndex(maxX - 1, newBlizz[2])
            elseif newBlizz[1] ≥ maxX
                newBlizz = CartesianIndex(2, newBlizz[2])
            elseif newBlizz[2] ≤ 1
                newBlizz = CartesianIndex(newBlizz[1], maxY - 1)
            elseif newBlizz[2] ≥ maxY
                newBlizz = CartesianIndex(newBlizz[1], 2)
            end

            # Push into new set
            push!(newWind,newBlizz)
        end

        # Replace the old set with the new set
        windMap[dirn] = newWind
    end

    # Return the updated blizzard
    return windMap
end

# Update the wind map
for i = 0:lcm(maxX - 2, maxY - 2)
    # println("Current time step: ", i)
    # displayBlizz(windHist[i], maxX, maxY)
    global windHist[i+1] = updateBlizzard(deepcopy(windHist[i]), maxX, maxY)
end
println("Maps made")

# Implement search
function solveMap(startPoint, endPoint)
    # Initialize search
    nodesToVisit = [startPoint]

    # Solve the problem
    while true
        # Make a list of all the nodes that change cost in this loop
        changedNodes = Set()

        # Visit all the keys in the "To-Visit" list
        for currNode in nodesToVisit
            if (CartesianIndex(currNode[1], currNode[2]) == endPoint)
                println("Destination reached: ", currNode)
                return currNode[3]
            end

            # Wrap around time based on wind cycle
            wrappedTime = mod(currNode[3] + 1, lcm(maxX-2, maxY-2))

            # Check all adjacents
            for (neighbour, reachable) in allNeighbours(currNode, windHist[wrappedTime], maxX, maxY)
                # Check if we can reach this point
                if reachable
                    push!(changedNodes, neighbour)
                end
            end
        end
        
        nodesToVisit = changedNodes
    end
end

# Solve the map
startPoint = CartesianIndex(2,1,0)
endPoint   = CartesianIndex(maxX - 1, maxY)

# Make up a heuristic cost
hCost = solveMap(startPoint, endPoint)

# Part 1
println("Cost to end: ", hCost)

# Part 2
# Go back to the start
startPoint = CartesianIndex(maxX - 1, maxY, hCost)
endPoint   = CartesianIndex(2,1)
hCost      = solveMap(startPoint, endPoint)

# Go back to the end
startPoint = CartesianIndex(2, 1, hCost)
endPoint   = CartesianIndex(maxX - 1, maxY)
hCost      = solveMap(startPoint, endPoint)


println("Cost to end: ", hCost)
