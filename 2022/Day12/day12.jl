# Read inputs
inputs = read(".\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")     # Sanitize inputs
inputs = strip(inputs,'\n')           # Trailing end line is annoying
inputs = split(inputs,'\n')           # Split into lines

# Convert the input into a matrix
terrainMap = reduce(hcat, split.(inputs,""))

# Find all neighbors for a node
function allNeighbours(currNode, terrainMap)
    # Make an empty list to store neighbours
    neighboursList = []

    # Find the node value
    currNodeVal = only(terrainMap[currNode[1], currNode[2]])

    # What's the terrain size?
    terrainSize = size(terrainMap)

    # What are the possible neighbours?
    moveDirs       = [(1,0),(0,1),(-1,0),(0,-1)]

    for move in moveDirs
        newNode    = Tuple(currNode) .+ move

        # Check if new node is within terrain bounds
        if terrainSize[1] +1 > newNode[1] > 0 && terrainSize[2] + 1> newNode[2] > 0
            # Check if new node is reachable
            newNodeVal = only(terrainMap[newNode[1], newNode[2]])

            if (currNodeVal - newNodeVal) ≤ 1
                # println(currNodeVal*newNodeVal, " is legal")
                push!(neighboursList, (newNode, 1))
            else
                push!(neighboursList, (newNode, Inf))
                # println(currNodeVal*newNodeVal, " is illegal")
            end
        end
    end
    return neighboursList
end

# Locate the start point and the end point
startPoint = Tuple(findfirst(x -> x == "E", terrainMap))
endPoint   = Tuple(findfirst(x -> x == "S", terrainMap))

# Replace start and end point with their corresponding heights
terrainMap[startPoint[1], startPoint[2]] = "z"
terrainMap[endPoint[1], endPoint[2]]     = "a"

# Find all the a nodes
aNodes     = Tuple.(findall(x-> x == "a", terrainMap))

# Find the path to the end
terrainSize    = size(terrainMap)
unvisitedNodes = Set(Iterators.product(1:terrainSize[1],1:terrainSize[2]))
costMap        = Dict()

# Initialize the map
nodesToVisit        = [startPoint]
costMap[startPoint] = 0

# Implement A star
while true
    # Make a list of all the nodes that change cost in this loop
    changedNodes = []

    # Visit all the keys in the "To-Visit" list
    for currNode in nodesToVisit
        # Check all adjacents
        for (neighbour, cost) in allNeighbours(currNode, terrainMap)
            # Calculate cost to the next node
            testCost = cost + costMap[currNode]

            # Check if this is the minimum cost
            if neighbour in unvisitedNodes || costMap[neighbour] > testCost
                costMap[neighbour] = testCost
                push!(changedNodes, neighbour)
                delete!(unvisitedNodes, neighbour)
            end

            # Check move
            # println(currNode, " -> ", neighbour," cost = ", testCost)
        end
    end

    # If no nodes changed, end the loop
    if length(changedNodes) == 0
        break
    else
        # If some nodes changed, visit them on the next pass-through
        global nodesToVisit = changedNodes
    end
end

# What is the cost to visit the end node from the start node?
println("Cost to end: ", costMap[endPoint])

# What is the cost to visit the end node from the start node?
minCostVal = minimum(map(x-> costMap[x], aNodes))
println("Min cost from a-> z : ", minCostVal)
