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

pathSet  = unique(pathSet)
numRocks = length(pathSet)

# Find the bounds
(minX, minY) = map( x -> minimum(map(y -> y[x] ,pathSet)),1:2)
(maxX, maxY) = map( x -> maximum(map(y -> y[x] ,pathSet)),1:2)

# Make a matrix to map the cave
depth = maxY + 3

maxX = max(maxX, 500 + depth)
minX = min(minX, 500 - depth) + 2

width = maxX - minX + 1
sandMatrix = falses(width,depth)

# Fix all the points in the pathSet to start at 1,1
pathSet = map( x-> (x[1] - minX + 1, x[2] + 1), pathSet)

# Set all the rocky points to true
sandMatrix[CartesianIndex.(pathSet)] .= true
# display(sandMatrix)

# Where is the floor?
floorY = depth
println("Floor at ", floorY)

# List all possible moves for a grain of sand
moveTypes = CartesianIndex.([(-1,1),(0,1),(1,1)]) # L, D, R

# Start adding sand
fallingOff = false
numGrains  = 0

# println(pathSet)

while true
    # Start at the sand origin
    currPos = [CartesianIndex(500 - minX + 1,1)]

    # Keep moving the grain till it hits something or falls of the edge
    while length(currPos) > 0
        # println("Move grain to next pos ", currPos)
        # Check if floor is hit
        if currPos[1][2] == floorY - 1
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
    if floorY == 1
        # println(currPos)
        break
    end

    # Remove all the points in the set that are lower than the current floor
    # global pathSet = filter(x -> x[2] < floorY, pathSet)
end

# Print the number of added grains
println("Added grains = ", numGrains)
    
