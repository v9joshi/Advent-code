# Read inputs
inputs = read(".\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")     # Sanitize inputs
inputs = strip(inputs,'\n')           # Trailing end line is annoying
inputs = split(inputs,"\n\n")         # Split into blocks

# Make a mutable struct to define a monkey
mutable struct Monkey
    numOps
    itemList::Vector{Any}
    Operation
    Test
end

# Make a list of all the divisors
divisorList::Vector{Int} = []

# Make a dict of monkeys
monkeyDict = Dict()

# Define the monkeys
for inputBlock in inputs
    # Break the block into lines
    inputLines = split(inputBlock,'\n')

    # Get the monkey number
    monkeyIndex = parse(Int,split(strip(inputLines[1],':'),' ')[2])

    # Read the starting items
    startingItems = parse.(Int, split(split(inputLines[2],": ")[end],", "))
    
    # Check the operation
    opValue = split(inputLines[3]," ")[end]

    if opValue == "old"
        global OpFun = (x) -> x * x
    elseif occursin("+", inputLines[3])
        global OpFun = (x) -> x + parse(Int,opValue)
    else
        global OpFun = (x) -> x * parse(Int,opValue)
    end
    
    # Check the test
    testValue  = parse(Int, split(inputLines[4]," ")[end])
    passMonkey = parse(Int, split(inputLines[5]," ")[end])
    failMonkey = parse(Int, split(inputLines[6]," ")[end])

    TestFun(x) = (mod(x, testValue) == 0) ? passMonkey : failMonkey

    # Add the test value to the divisor list
    push!(divisorList, testValue)

    # Make the monkey
    currMonkey = Monkey(0, startingItems, OpFun, TestFun)

    # Store the monkey
    monkeyDict[monkeyIndex] = currMonkey
end

# Run the process num rounds times
numRounds = 10000
divisorProd = lcm(divisorList)

for currRound = 1:numRounds
    # Run monkey operations in order
    for currMonkey = 0:(length(keys(monkeyDict)) - 1)

        # Get the current monkeys items
        while length(monkeyDict[currMonkey].itemList) > 0
            # Increase the number of operations
            monkeyDict[currMonkey].numOps = monkeyDict[currMonkey].numOps + 1 

            # Examine the items one at a time
            currItem = popfirst!(monkeyDict[currMonkey].itemList)

            # print(currItem, " -> ")

            # Do the examination
            currItem = monkeyDict[currMonkey].Operation(currItem)

            # print(currItem, " -> ")

            # Decrease worry
            # currItem = Int(floor(currItem/3))   # -> Part 1 
            currItem = mod(currItem, divisorProd) # -> Part 2

            # println(currItem)

            # Test the item
            targetMonkey = monkeyDict[currMonkey].Test(currItem)

            # Throw to new monkey
            push!(monkeyDict[targetMonkey].itemList, currItem)

            # Print this interaction
            # println("Item ", currItem, " from ", currMonkey, " to ", targetMonkey)
        end
    end
end

# Find the number of operations for each monkey
numOps = map(x -> x.numOps, values(monkeyDict))
println(numOps)

# Multiply the top 2 and return the answer
println("Monkey business = ", prod(numOps[partialsortperm(numOps,1:2,rev = true)]))