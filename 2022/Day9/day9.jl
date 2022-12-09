# Read inputs
inputs = read(".\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")     # Sanitize inputs
inputs = strip(inputs,'\n')           # Trailing end line is annoying
inputs = split(inputs,'\n')           # Split into lines

# Set the start point of the head and the tail
numTails  = 9
ropePos  = repeat([0,0]', numTails+1)

tailHist1 = Set([ropePos[2,:]])
tailHist2 = Set([ropePos[end,:]])

# Map the directions to a vector
dirMap = Dict("R" => [0,1], "L" => [0,-1], "U" => [1,0], "D" => [-1,0])

# Make a function to update tail pos
function updateTail(headPos, tailPos)
    # What's the distance between the two points?
    distance = headPos - tailPos

    # Use distance to determine the movement of the tail
    # if head is adjacent, don't move tail
    if maximum(abs.(distance)) < 2
        return [0,0]
    # Otherwise move tail till head is adjacent
    else
        return map(x -> (abs(x) > 0)*sign(x), distance)
    end
end

# Read and execute the moves
for move in inputs
    # Parse the command
    (direction, amount) = split(move,' ')

    # Update the head pos and tail pos
    for stepNum = 1:parse(Int, amount)
        global ropePos[1,:]  = ropePos[1,:] + dirMap[direction]
        
        for currTail = 2:(numTails+1)
            global ropePos[currTail,:] = ropePos[currTail,:] + updateTail(ropePos[currTail-1,:], ropePos[currTail,:])
        end

        # Store the tail positions of interest
        push!(tailHist1, ropePos[2,:])
        push!(tailHist2, ropePos[end,:])
    end
end

# How many unique positions does the tail occupy?
println("Num positions 1 = ", length(tailHist1))
println("Num positions 2 = ", length(tailHist2))