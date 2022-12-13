# Read inputs
inputs = read(".\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")     # Sanitize inputs
inputs = strip(inputs,'\n')           # Trailing end line is annoying
inputs = split(inputs,"\n\n")         # Split into blocks


# Make packet checking functions
function packetChecker(leftInt::Int, rightInt::Int)
    # println(leftInt, " int vs int ", rightInt)
    return leftInt < rightInt
end

function packetChecker(leftList::Vector{}, rightList::Vector{})
    # Run pairwise comparisons of the list elements
    for (leftEle, rightEle) in zip(leftList, rightList)
        # println(leftEle, "  vec vs vec ", rightEle)

        # If left < right then true
        if packetChecker(leftEle, rightEle)
            # println("checked - Right order")
            return true
        # If right < left then false
        elseif packetChecker(rightEle, leftEle)
            # println("checked - Wrong order")
            return false
        end
    end

    # If the loop is over without returning, one of the lists must be empty
    return packetChecker(length(leftList), length(rightList))
end

# Right is an int but left is a list, make right a list
function packetChecker(leftList::Vector{}, rightList::Int)
    # println(leftList, " vec vs int ", rightList, " Add []")
    return packetChecker(leftList,[rightList])
end

# Left is an int but right is a list, make left a list
function packetChecker(leftList::Int, rightList::Vector{})
    # println(leftList, " int vs vec ", rightList, " Add []")
    return packetChecker([leftList],rightList)
end

# Split the block into lines and check if the packets are in order
correctOrderList = []
fullList = []
for (blockNum, block) in enumerate(inputs)
    packets = split(block,'\n')
    (packetLeft, packetRight) = eval.(Meta.parse.(packets))
    
    # If packets are in order, add to list
    # println(packetLeft, " vs ", packetRight)
    
    if packetChecker(packetLeft, packetRight) == true
        # println("Correct order")
        push!(correctOrderList, blockNum)
    else
        # println("Wrong order")
    end

    # Store all the lists
    push!(fullList, packetLeft)
    push!(fullList, packetRight)
end

# Print the result
println("Blocks with the right order: ", correctOrderList)
println("Sum of indices = ", sum(correctOrderList))

# Part 2
dividers = [[[2]],[[6]]]
pushfirst!(fullList, dividers[1])
push!(fullList, dividers[2])

# Run a sort
sortedList = sort(fullList, lt = packetChecker)
dividerIndex = map(x -> findfirst(==(x),sortedList),dividers)

println("Product of the indices = ", prod(dividerIndex))