inputs = read(".\\testInput.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")     # Sanitize inputs
inputs = strip(inputs,'\n')           # Trailing end line is annoying

# Split the input into lines
inputLines = split(inputs,"\n")

# Given x and y, find all possible integer solutions z such that
# z*(x - z) > y
# -> z*x - z^2 > y
# -> z*x - z^2 - y > 0
# z = (x +/- sqrt(x^2 - 4*y))/2
# Find the number of integers between z1 and z2

# Version 1
timesStr   = split(inputLines[1], ":")[2]
times1     = parse.(Int, map(x -> timesStr[x], findall(r"\d+", timesStr)))

distStr    = split(inputLines[2], ":")[2]
distances1 = parse.(Int, map(x -> distStr[x], findall(r"\d+", distStr)))

# Version 2
timesStr   = split(inputLines[1], ":")[2]
times2     = parse(Int, join(map(x -> timesStr[x], findall(r"\d+", timesStr))))

distStr    = split(inputLines[2], ":")[2]
distances2 = parse(Int, join(map(x -> distStr[x], findall(r"\d+", distStr))))

# Find all possible sols
numSols = []

for (time, distance) in Iterators.zip(times2,distances2)
    sol1 = (time - sqrt(time^2 - 4*distance))/(2)
    sol2 = (time + sqrt(time^2 - 4*distance))/(2)

    # Account for exact integer solutions
    minSol = floor(sol1 + 1)
    maxSol = ceil(sol2 - 1)

    push!(numSols, maxSol - minSol + 1)
end

# What's the answer
println("Answer pt#1: ", numSols |> prod)
