# Read inputs
inputs = read(".\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")     # Sanitize inputs
inputs = strip(inputs,'\n')           # Trailing end line is annoying

# Store the numbers
codeNumbers = parse.(Int,split(inputs,"\n")).*811589153

# Start mixing
numCodes    = length(codeNumbers)
newIndex    = collect(1:numCodes)

for mixNum = 1:10
    for currMover = 1:numCodes
        # Find where this number is located
        currIndex = indexin(currMover, newIndex)[1]

        # How much does this number move?
        distMove  = codeNumbers[currMover]
        desIndex  = currIndex + distMove

        # Wrap this new index
        desIndex = mod(desIndex-1, numCodes-1) + 1
        if desIndex == 1
            desIndex = numCodes
        end


        # println(codeNumbers[currMover], " moves from ", currIndex, " by ", distMove, " to ", desIndex)

        # Make a temporary new index
        tempNewIndex = deepcopy(newIndex)

        for (idxIdx, idxVal) in enumerate(newIndex)
            if idxIdx == currIndex
                # println("Moving ", codeNumbers[idxIdx], " to ", desIndex)
                tempNewIndex[desIndex] = idxVal
            elseif max(currIndex, desIndex) ≥ idxIdx ≥ min(currIndex, desIndex)
                # println("Moving ", codeNumbers[idxIdx], " to ", idxVal - sign(desIndex - currIndex))
                tempNewIndex[idxIdx - sign(desIndex - currIndex)] = idxVal
            end
        end

        # Sub the new indices in
        global newIndex = deepcopy(tempNewIndex)
        # println(newIndex)
        # println(codeNumbers[newIndex])
    end
end
# println(codeNumbers[newIndex])


# Locate indices 1000, 2000 and 3000
locationZero = indexin(indexin(0,codeNumbers)[1],newIndex)[1]
println(locationZero)
println(codeNumbers[newIndex[locationZero]])
total = 0
for targetIdx in [1000,2000,3000]
    # Where do we need to look?
    targetIdx = targetIdx + locationZero

    # Wrap around the list
    targetIdx = mod(targetIdx -1, numCodes) + 1

    println(codeNumbers[newIndex[targetIdx]])

    # Get the value
    global total = total + codeNumbers[newIndex[targetIdx]]
end

# What's the total?
println("Total #1 = ", total)
