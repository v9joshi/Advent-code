# Read inputs
inputs = read(".\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")     # Sanitize inputs
inputs = strip(inputs,'\n')           # Trailing end line is annoying
inputs = split(inputs,"\n")           # Split into lines

# Make a function to convert to base 10
function translate(number)
    currNum = 0
    for (idx, num) in enumerate(split(reverse(number),""))
        currNum = currNum + symMap[num]*(5^(idx-1))
    end
    return currNum
end

# Convert all the numbers to base 10
symMap = Dict("2"=>2, "1"=>1, "0"=>0, "-"=>-1, "="=>-2)
nums10 = []


for number in inputs
    push!(nums10, translate(number))
end

# Convert the sum to the old format
fuelSum = sum(nums10)
maxExp = Int(floor(log(5,fuelSum)) + 1)
convSum = []

for idx = maxExp:-1:0
    # What's the effect of each possible "digit"
    posValues = []
    for sym in keys(symMap)
        testVal = abs(fuelSum - symMap[sym]*5^(idx))
        push!(posValues, (testVal, sym))
    end

    # Find the minimum
    posValues        = sort(posValues)[1]
    push!(convSum, posValues[2])
    global fuelSum   = fuelSum - symMap[posValues[2]]*5^(idx)
end

# Print the answer
println("Val: ", join(convSum), " = ", translate(join(convSum)))