# Read inputs
inputs = read(".\\input.txt", String)     # Read all the inputs
inputs = replace(inputs,'\r'=>"")         # Sanitize inputs
inputs = strip(inputs,'\n')               # Trailing end line is annoying
inputs = split.(inputs,'\n')              # Split blocks of data into different vectors

# Split into pairs and find overlaps
fullOverlaps    = []
partialOverlaps = []

for currPair = 1:length(inputs)
    pairRanges = split.(inputs[currPair],",")
    pairRanges = split.(pairRanges,"-")

    range1 = parse.(Int, pairRanges[1])
    range1 = range1[1]:range1[2]

    range2 = parse.(Int, pairRanges[2])
    range2 = range2[1]:range2[2]

    # Check full overlaps
    if (range1 ⊆ range2)
        push!(fullOverlaps, range1)
    elseif (range2 ⊆ range1)
        push!(fullOverlaps, range2)
    end

    # Check the partial overlaps
    if !isdisjoint(range1, range2)
        push!(partialOverlaps, intersect(range1, range2))
    end
end

# How many overlaps are there?
println("# full overlaps = ", length(fullOverlaps))
print("# partial overlaps = ", length(partialOverlaps))