# Read inputs
inputs = read(".\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")     # Sanitize inputs
inputs = strip(inputs,'\n')           # Trailing end line is annoying
inputs = split(inputs,'\n')           # Split into lines

# Convert inputs into a matrix
treeMatrix = parse.(Int, reduce(hcat,split.(inputs,"")))

# What is the matrix size?
(maxX, maxY) = size(treeMatrix)

# Make a visibility dictionary
visibleDict = Dict()
scenicScore = Dict()

# Find the number of trees visible from current tree
function SceneCheck(currTree, otherTrees)
    # Find the first tree in the given range that's
    # as big or bigger than the current tree
    index = findfirst(x -> x ≥ currTree, otherTrees)

    # Check if the tree is being blocked, and if yes by how many trees
    return (something(index, length(otherTrees)), ~isnothing(index))
end

for (idx, idy) in Iterators.product(2:maxX-1,2:maxY-1)
    # Get the trees to the left and right
    currLeft  = reverse(treeMatrix[1:idx-1,idy])
    currRight = treeMatrix[idx+1:end,idy]

    # Get the trees to the top and bottom
    currTop   = reverse(treeMatrix[idx,1:idy-1])
    currBot   = treeMatrix[idx,idy+1:end]

    # Get current element
    currEle = treeMatrix[idx, idy]

    # Find first blocking tree in each direction
    (scoreLeft,  visLeft)  = SceneCheck(currEle, currLeft)
    (scoreRight, visRight) = SceneCheck(currEle, currRight)
    (scoreTop,   visTop)   = SceneCheck(currEle, currTop)
    (scoreBot,   visBot)   = SceneCheck(currEle, currBot)

    # Find the scenic score and the visibility
    scenicScore[(idx, idy)] = scoreLeft*scoreRight*scoreTop*scoreBot
    visibleDict[(idx,idy)]  = visLeft*visRight*visTop*visBot
end

# How many trees are visible?
println("Num visible = ", maxX*maxY - (map(x -> x == 1, values(visibleDict)) |> sum ))

# What's the max scenic score?
println("Max score = ", maximum(values(scenicScore)))