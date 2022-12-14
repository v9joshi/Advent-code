# Read inputs
inputs = read(".\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")     # Sanitize inputs
inputs = strip(inputs,'\n')           # Trailing end line is annoying
inputs = split(inputs,'\n')           # Split into blocks

# Read each line at a time, and add points to path set
pathSet = []
for line in inputs
    # Get all the nodes
    nodes = split(line," -> ")

    # Look at nodes in pairs
    for (startNode, endNode) in zip(nodes[1:end-1], nodes[2:end])
        # Convert the strings to numbers
        startNode = parse.(Int, split(startNode,','))
        endNode   = parse.(Int, split(endNode,','))

        # Push all nodes in the path to the path set
        listX = (startNode[1] < endNode[1]) ? (startNode[1]:endNode[1]) : (endNode[1]:startNode[1])
        listY = (startNode[2] < endNode[2]) ? (startNode[2]:endNode[2]) : (endNode[2]:startNode[2])
        append!(pathSet, Iterators.product(listX, listY))
    end
end

# Find the bounds
(minX, minY) = map( x -> minimum(map(y -> y[x] ,pathSet)),1:2)
(maxX, maxY) = map( x -> maximum(map(y -> y[x] ,pathSet)),1:2)

# Where is the floor?
floorY = maxY

# Make a matrix to map the cave
depth = floorY + 3

maxX = max(maxX, 500 + depth + 2)
minX = min(minX, 500 - depth - 2)

width = maxX - minX + 1
sandMatrix = falses(width,depth)

# Fix all the points in the pathSet to start at 1,1
pathSet = map( x-> (x[1] - minX + 1, x[2] + 1), pathSet)

# Set all the rocky points to true
sandMatrix[CartesianIndex.(pathSet)] .= true
# display(sandMatrix)

# List all possible moves for a grain of sand
moveTypes = CartesianIndex.([(-1,1),(0,1),(1,1)]) # L, D, R

# Start adding sand
numGrains   = 0

while true
    # Start at the sand origin
    currPos = [CartesianIndex(500 - minX + 1,1)]
    numAdded = 0

    # Keep moving the grain till it hits something or falls of the edge
    while length(currPos) > 0
        # Has the sand fallen off?
        if currPos[1][2] > floorY
            break
        end

        # Does the sand settle?
        nextPos = map(move -> currPos[1] + move, moveTypes)
        if all(sandMatrix[nextPos])
            numAdded = numAdded + 1
            sandMatrix[currPos[1]] = true

            # Add the sand
            # println("Hit floor, added $numAdded grains")
            global numGrains = numGrains + numAdded
            break 
        elseif sandMatrix[nextPos[1]] && sandMatrix[nextPos[2]]
            currPos[1] = nextPos[3]
        elseif sandMatrix[nextPos[2]]
            currPos[1] = nextPos[1]
        else
            currPos[1] = nextPos[2]
        end
    end

    # End the loop when we stop adding sand
    if numAdded == 0
        break
    end
end

# Print the number of added grains
println("Added grains part 1 = ", numGrains)

# Solve part 2
floorY = maxY + 2

while true
    # Start at the sand origin
    currPos = [CartesianIndex(500 - minX + 1,1)]
    numAdded = 0

    # Keep moving the grain till it hits something or falls of the edge
    while length(currPos) > 0
        # println("Move grain to next pos ", currPos)
        # Check if floor is hit
        if currPos[1][2] == floorY
            # println(currPos)
            # Remove the bottom most row
            global floorY = floorY - 1

            # How many grains are added?
            sandMatrix[currPos] .= true
            numAdded = length(currPos)
            global numGrains = numGrains + numAdded
            
            # println("Hit floor, added $numAdded grains")
            break
        else
            # How will these grains expand on the next step?
            nextStep = map(pair -> pair[1] + pair[2], Iterators.product(currPos, moveTypes)) |> unique
    
            # Remove all intersections with the path set
            nextStep = filter(currPoint -> !sandMatrix[currPoint], nextStep)

            # Update the sand particle positions
            currPos = nextStep                
        end
    end

    # End the loop when we cover the sand source
    if floorY == 0
        # println(currPos)
        break
    end
end    

println("Added grains part 2 = ", numGrains)