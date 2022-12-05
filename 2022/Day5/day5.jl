# Read inputs
inputs = read(".\\input.txt", String)     # Read all the inputs
inputs = replace(inputs,'\r'=>"")         # Sanitize inputs
inputs = strip(inputs,'\n')               # Trailing end line is annoying
inputs = split.(inputs,"\n\n")            # Split input into initial arrangement and operation order

arrangement = inputs[1]
operations  = inputs[2]

arrangement = split(arrangement,'\n')

# Find the number of crates
numCrates = parse.(Int,split(arrangement[end],r"\s+")[2:end-1])[end]
boxArray = map(x -> [], 1:numCrates)

# Find the initial order
for currRow = 1:(length(arrangement) - 1)
    rowList = arrangement[currRow]
    rowEntries = rowList[2 + 0:4:4*(numCrates)]

    for (boxNum, boxVal) in enumerate(rowEntries)
        if !(boxVal == ' ')
            push!(boxArray[boxNum], boxVal)
        end
    end
end

# println(boxArray)

# Clone box array for a second crane
boxArray9001 = deepcopy(boxArray)

# Read the operations and execute them
for currOperation in split(operations,'\n')
    #println(currOperation)
    operationNums = split(currOperation,' ')
    
    numBoxes   = parse(Int,operationNums[2])
    startPoint = parse(Int, operationNums[4])
    endPoint   = parse(Int, operationNums[6])

    # Make a temp array for box mover 9001
    tempArray = []

    # Move the boxes
    for moveNum = 1:numBoxes
        # Box mover 9000
        if length(boxArray[startPoint]) > 0
             currBox = popfirst!(boxArray[startPoint])
             pushfirst!(boxArray[endPoint],currBox)
        end

        # Box mover 9001
        if length(boxArray9001[startPoint]) > 0
            currBox = popfirst!(boxArray9001[startPoint])
            pushfirst!(tempArray, currBox)
        end
    end

     # Now move boxes from temp array to the correct crate for box mover 9001
    for moveNum = 1:numBoxes
        # Box mover 9001
        if length(tempArray) > 0
            currBox = popfirst!(tempArray)
            pushfirst!(boxArray9001[endPoint], currBox)
        end
    end

#     # println(boxArray)
end

# print(boxArray)

# Find the top box from each column
topBoxList9000 = join(map(x -> x[1], filter(x -> length(x) > 0, boxArray)))
topBoxList9001 = join(map(x -> x[1], filter(x -> length(x) > 0, boxArray9001)))
println("Mover 9000: ", topBoxList9000)
print("Mover 9001: ", topBoxList9001)
# print(topRow)
