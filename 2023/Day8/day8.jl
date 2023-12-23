inputs = read(".\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")     # Sanitize inputs
inputs = strip(inputs,'\n')           # Trailing end line is annoying

# Split the input into sections
inputSections = split(inputs,"\n\n")

# Section 1 contains the instructions
instructionList = split(inputSections[1],"")

# Section 2 contains the map
mapInput = Dict()
for line = split(inputSections[2],'\n')
    mapKey, mapVal   = split(line, " = ")

    # Clean the map val to remove brackets
    mapVal = strip(mapVal, ['(',')'])
    mapValL, mapValR = split(mapVal, ", ")

    global mapInput[mapKey] = [mapValL, mapValR]
end

# # Now step through the map till you reach the destination
# startPos = "AAA"
# endPos   = "ZZZ"

# numSteps = 0
# currPos   = startPos

# while !(currPos == endPos)   
#     direction = instructionList[mod(numSteps, length(instructionList)) + 1]
#     # println("Step: ", numSteps + 1, ", direction:", direction)

#     newPos    = contains(direction,'R') ? mapInput[currPos][2] : mapInput[currPos][1]

#     # Update the current location and number of steps
#     global currPos = newPos
#     global numSteps = numSteps + 1
#     # println(newPos)
# end

# Answer to pt 1
# println("Num steps in part 1: ", numSteps)


# Ghost version
startPos     = [currLoc for currLoc in keys(mapInput) if (currLoc[end] == 'A')]
numStepsList = Vector{Int64}([])

for pos = startPos
    
    currPos  = pos
    numSteps = 0
    while !(currPos[end] == 'Z')   
        direction = instructionList[mod(numSteps, length(instructionList)) + 1]
        newPos    = contains(direction,'R') ? mapInput[currPos][2] : mapInput[currPos][1]
    
        # Update the current location and number of steps
        currPos = newPos
        numSteps = numSteps + 1
    end

    # Store the number of steps
    append!(numStepsList, numSteps)
end

# Answer for pt 2
println(numStepsList)
println("Num steps in part 2: ", lcm(numStepsList))
