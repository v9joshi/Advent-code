inputs = read(".\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")         # Sanitize inputs
inputs = strip(inputs,'\n')               # Trailing end line is annoying
inputs = split.(inputs,"\n\n")            # Split blocks of data into different vectors

# Convert blocks into arrays
inputs = split.(inputs,'\n')

# Parse arrays as numbers and store them
elfTotalCal = [];

for elfNum = 1:length(inputs)
    currElfCal    = parse.(Int,inputs[elfNum])
    currElfTotalCal = sum(currElfCal)
    push!(elfTotalCal, currElfTotalCal)
end

# What's the highest cal count and which elf has it?
maxIndexAndVal = findmax(elfTotalCal)
print("Max cal value: ", maxIndexAndVal[1]," carried by elf num: ", maxIndexAndVal[2],'\n')

# Find the top 3 elves
topThreeCals = elfTotalCal[partialsortperm(elfTotalCal,1:3,rev=true)]
print("Top three elves have: ", sum(topThreeCals))