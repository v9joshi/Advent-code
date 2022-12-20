# Read inputs
inputs = read(".\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")         # Sanitize inputs
inputs = strip(inputs,'\n')               # Trailing end line is annoying
inputs = split(inputs, "")                # Split into characters
numJet = length(inputs)

# Make the shapes
shapes    = Dict()
shapeBox  = CartesianIndex.(Iterators.product(1:4,-4:-1)) # A 4x4 grid
shapes[1] = shapeBox[1:4,4] # Horizontal line 

shapes[2] = shapeBox[2,2:4] # A plus shape
append!(shapes[2], shapeBox[1:2:3,3])

shapes[3] = shapeBox[3,2:4] # L shape
append!(shapes[3], shapeBox[1:2,4])

shapes[4] = shapeBox[1,1:4] # Vertical line

shapes[5] = shapeBox[1,3:4] # Box
append!(shapes[5], shapeBox[2,3:4])

# Define the move map
moveMap = Dict(">" => CartesianIndex(1,0), "<" => CartesianIndex(-1,0), "v" => CartesianIndex(0,+1))

# Keep running till N rocks have settled
nRocks    = 1e12# 1e12 #e13

# Reduce this to a smaller set, knowing each Rep after the first adds 1730 rocks and 2647 to the height
nRocks    = nRocks - 1723 # First cycle adds 1723 rocks
numReps   = Int(floor(nRocks/1730))
nRocks    = nRocks - numReps*1730 + 1723

println(nRocks + 1730*numReps)

currRocks = 0
downstep  = false

rockFloor   = Set(CartesianIndex.(Iterators.product(1:7,0)))
currCeil    = 0

newRock     = true
currShape   = shapes[1]

repNum      = 0
stepNum     = 0

while currRocks < nRocks
    if newRock
        # Select the shape
        global currShape = shapes[mod(currRocks,5) + 1]
        # println(currShape)

        # Where's the ceiling?
        ceilingRow = minimum(rockFloor)[2]

        # Start the shape at col = left +2, row = ceilingRow + 3
        offsetPos = CartesianIndex(2, ceilingRow - 3)
        currShape = currShape .+ repeat([offsetPos], length(currShape))

        # No more new rock
        global newRock = false
    end

    # What's the jet input?
    if downstep
        jetInput = "v"
    else
        jetInput = popfirst!(inputs)
        push!(inputs, jetInput)
        global stepNum = mod(stepNum + 1, numJet)
        if stepNum == 0
            global repNum = repNum + 1
            println(repNum, ",",minimum(rockFloor)[2], ",", currRocks)
        end
    end

    # What's the move?
    movement = moveMap[jetInput]

    # Make the movement
    tempShape = currShape .+ repeat([movement], length(currShape))
    #println(currShape)

    if currRocks > 157
        # println(currShape)
        # println("Floor = ", rockFloor[:,end])
    end

    # Check wall collision
    if maximum(tempShape)[1] > 7 || minimum(tempShape)[1] < 1
        # println("Hitting wall")
    # Check floor collision
    elseif length(intersect(rockFloor, tempShape)) > 0 && !downstep
        # println("Hitting floor while moving sideways")
    elseif length(intersect(rockFloor, tempShape)) > 0 && downstep
        # println("Hitting floor while moving down")
        global currRocks = currRocks + 1
        # println(currRocks)

        # Add all these rocks to the floor
        for rock in currShape 
            push!(rockFloor, rock)
        end

        # Drop a new rock
        global newRock = true
        # println("Ceiling = ", maximum(rockFloor)[2])
    else
        # println("Moved succesfully")
        global currShape = deepcopy(tempShape)
    end

    # Increase the step counter
   global  downstep = !downstep
end

# Where's the ceiling at the end of this?
println("Ceiling #1 = ", minimum(rockFloor)[2])

println("Ceiling #2 = ", minimum(rockFloor)[2] - numReps*2647)

# Make a shape to display
# dispHeight = maximum(rockFloor)[2] - minimum(rockFloor)[2] + 1
# dispMatrix = falses(dispHeight,7)
# for rock in rockFloor
#     dispMatrix[dispHeight + rock[2], rock[1]] = true
# end
# display(dispMatrix)