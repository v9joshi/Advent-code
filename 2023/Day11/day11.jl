using Combinatorics 

inputs = read(".\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")     # Sanitize inputs
inputs = strip(inputs,'\n')           # Trailing end line is annoying

# Split into lines
inputLines = split(inputs,'\n')

# Use the input to make a map
inputMap = reduce(vcat, permutedims.(collect.(inputLines))) 
println("Original: ", size(inputMap))

# Find empty columns and rows
emptyRows = []
emptyCols = []
for rowNum = 1:size(inputMap,1)
    line = join(inputMap[rowNum, :],"")
    if !contains(line, '#')
        # println("Row: ", rowNum," is empty")
        push!(emptyRows, rowNum)
    end
end

for colNum = 1:size(inputMap,2)
    line = join(inputMap[:, colNum])

    if !contains(line, '#')
        # println("Col: ", colNum," is empty")
        push!(emptyCols, colNum)
    end
end

# Find the manhattan distance between pairs of galaxies
galaxyPos = findall(x-> x=='#', inputMap)
distances = []
expRate   = 1000000

for (g1, g2) = Combinatorics.combinations(galaxyPos,2)
    # Find the number of empty rows and columns that lie between these two galaxies
    numEmptyRow = sum(map(x -> (x - g1[1])*(x - g2[1]) < 0, emptyRows))
    numEmptyCol = sum(map(x -> (x - g1[2])*(x - g2[2]) < 0, emptyCols))

    # Find the manhattan distance
    currDist = abs(g1[1] - g2[1]) + abs(g1[2] - g2[2]) + (expRate - 1)*(numEmptyCol + numEmptyRow)
    push!(distances, currDist)
end

println("Sum of distances = ", sum(distances))