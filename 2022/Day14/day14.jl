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

        for (x,y) in Iterators.product(listX, listY)
            push!(pathSet,(x,y))
        end
    end
end
pathSet = unique(pathSet)

# Find the bounds
(minX, minY) = map( x -> minimum(map(y -> y[x] ,pathSet)),1:2)
(maxX, maxY) = map( x -> maximum(map(y -> y[x] ,pathSet)),1:2)

# Where is the floor?
println("Floor at ", maxY + 2)

# Start adding sand
fallingOff = false
numGrains  = 0

# println(pathSet)

while !((500,0) in pathSet)
    # Start at the sand origin
    currPos          = (500,0)

    # Keep moving the grain till it hits something or falls of the edge
    while true
        # println("Move grain to next pos ", currPos)
        # Find the set of three possible moves
        nextD = currPos .+ ( 0,1)
        nextL = currPos .+ (-1,1)
        nextR = currPos .+ ( 1,1)

        # Did the sand grain move?
        change = 0
        # println("nextD = ", nextD)

        # Check if floor is hit
        if currPos[2] == maxY + 1
            # println(currPos)
            push!(pathSet, currPos)
            global numGrains = numGrains + 1
            # println("Hit floor")
            break
        end

        # Check all moves
        if !(nextD in pathSet)
            # Can move down
            currPos = nextD
        end

        if (nextD in pathSet) && (nextL in pathSet) && (nextR in pathSet)
            global numGrains = numGrains + 1
            push!(pathSet, currPos)
            break
        elseif (nextD in pathSet) && (nextL in pathSet)
            currPos = nextR
        elseif (nextD in pathSet)
            currPos = nextL
        else
            currPos = nextD
        end

        # Are we falling off the edge?
        if (500,0) in pathSet
            global fallingOff = true
            break
        end
    end
end

# Print the number of added grains
println("Added grains = ", numGrains)
    
