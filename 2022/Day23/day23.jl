# Read inputs
inputs = read(".\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")     # Sanitize inputs
inputs = strip(inputs,'\n')           # Trailing end line is annoying
inputs = split(inputs,"\n")           # Split into lines

# Make a list of elf positions
elfPos = Set()
for (rowNum, line) in enumerate(inputs)
    for colNum in findall(contains("#"), split(line,""))
        push!(elfPos,CartesianIndex(colNum, rowNum))
    end
end

# Generate neighbours
Δ = Dict()
Δ[0] = CartesianIndex.(Iterators.product(-1:1,-1))
Δ[1] = CartesianIndex.(Iterators.product(-1:1, 1))
Δ[2] = CartesianIndex.(Iterators.product(-1,-1:1))
Δ[3] = CartesianIndex.(Iterators.product( 1,-1:1))

# Start steps
stepNum = 0
while true
    # List the set of all possible moves for the elves
    moveList = Dict()
    numValidMoves = 0

    # First half
    # Loop over the elves to find their desired moves
    for elf in elfPos
        # What's the neighbour count?
        neighbourCount = 0

        # Check all dirns
        for currDir in 0:4
            # Find all neighbours in the current direction
            neighbours = repeat([elf],3) + Δ[mod(stepNum + currDir,4)]   

            # Increase the neighbour count, doesn't have to be accurate
            neighbourCount = neighbourCount + length(intersect(neighbours, elfPos))

            # Find the desired move for this elf
            if length(intersect(neighbours, elfPos)) > 0 || (elf in keys(moveList))
                continue
            else              
                moveList[elf] = neighbours[2]
            end
        end

        # If no valid move, stay in place
        if neighbourCount == 0
            moveList[elf] = elf
        end
    end

    # Second half
    # Move the elves
    # println(stepNum)
    for elf in keys(moveList)
        # println(elf, " -> ", moveList[elf])
        # Check if valid move
        moveCount = map(x -> x == moveList[elf], values(moveList)) |> sum
        if moveCount > 1
            # Don't move this elf
            # println("Moving to the same pos as a different elf, don't move")
        else            
            # If the elf moves, increase counter by 1
            if !(elf == moveList[elf])
                numValidMoves = numValidMoves + 1
            end

            # Make the move
            delete!(elfPos, elf)
            push!(elfPos, moveList[elf])
        end
    end
    # Print after each round
    # println(elfPos)
    # If no valid moves stop simulating
    if numValidMoves == 0
        println("Stop at step num :", stepNum + 1)
        break
    else
        # println("Step num :", stepNum + 1," valid moves:", numValidMoves)
    end

    # Increment step count
    global stepNum = stepNum + 1
end

# Find the surrounding box for the elves
minXY    = minimum(elfPos)
maxXY    = maximum(elfPos)
boxRange = maxXY - minXY

# Area of the box
println("Part #1, box area = ", (boxRange[1] + 1)*(boxRange[2] + 1) - length(elfPos))
