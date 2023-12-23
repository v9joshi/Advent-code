inputs = read(".\\testInput.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")     # Sanitize inputs
inputs = strip(inputs,'\n')           # Trailing end line is annoying

# Split the input into sections
inputSections = split(inputs,"\n\n")
dictOfDicts = Dict()
listOfSeeds2 = []

# Make maps from each section
for (secNum, section) = enumerate(inputSections)
    # See if this is the starting section
    if contains(section,"seeds:")
        _, seedNames = split(section,": ")
        global listOfSeeds = parse.(Int, split(seedNames,' '))

        for seedNum = range(1,length(listOfSeeds); step = 2)
            push!(listOfSeeds2, range(listOfSeeds[seedNum]; length = listOfSeeds[seedNum + 1]))
        end
    else
        # Split the section into lines
        lines = split(section,'\n')

        # Take the first line to make the dict
        global dictOfDicts[secNum - 1] = Dict()

        # Read the lines one at a time
        for line = lines[2:end]
            startDestination, startSource, numEles = parse.(Int, split(line,' '))
            global dictOfDicts[secNum - 1][startSource:(startSource + numEles - 1)] = startDestination
        end
    end
end

# Start the mapping
locationVal = Dict()

for currSeed = listOfSeeds
    global locationVal[currSeed] = currSeed

    # Convert one at a time
    for conversionNum = 1:length(keys(dictOfDicts))
        # Look at each of the sources for this conversion
        for sourceRange = keys(dictOfDicts[conversionNum])
            if locationVal[currSeed] in sourceRange
                global locationVal[currSeed] = (locationVal[currSeed] - sourceRange[1]) + dictOfDicts[conversionNum][sourceRange]
                break
            end
        end
    end
end

# Print the answer for part 1
println("Part 1 answer:", minimum(values(locationVal)))

# Make a range intersection function
function splitTheRanges(range1, range2)
    # Find the intersection of the two ranges
    rangeIntersect = intersect(range1, range2)

    # If the ranges intersect completely or not at all return the original range
    if (length(rangeIntersect) == length(range1))
        # println(range1, " lies within ", range2, " give:", range1)
        return [range1]
    elseif (length(rangeIntersect) == 0)
        # println(range1, " does not intersect ", range2, " give:", range1)
        return [range1]
    # If the overlap is the testing region
    elseif (length(rangeIntersect) == length(range2))
        # println(range1, " partially overlaps ", range2, " give: ", [range1[1]:range2[1], range2[2:end-1], range2[end]:range1[end]])
        return [range1[1]:(range2[1] - 1), range2[1:end], (range2[end] + 1):range1[end]]
    # If the ranges intersect partially then return the 2 pieces
    elseif range1[1] < range2[1]
        # println(range1, " partially overlaps ", range2, " give: ", [rangeIntersect, diffBetween[1]:diffBetween[end]])
        return [range1[1]:(range2[1] - 1), rangeIntersect]
    elseif range1[1] > range2[1]
        # println(range1, " partially overlaps ", range2, " give: ", [rangeIntersect, diffBetween[1]:diffBetween[end]])
        return [(range2[end] + 1):range1[end], rangeIntersect]
    end
end

# Part 2
# Do each conversion one at a time
for conversionNum = 1:length(keys(dictOfDicts))
    # Split the seed ranges if needed
    # println("Starting list:", listOfSeeds2)
    # println(dictOfDicts[conversionNum])
           
    # Check where each seed range overlaps the sources in the dictionary
    for sourceRange = keys(dictOfDicts[conversionNum])
        splitRange = []
        for currRange = listOfSeeds2
            splitList = splitTheRanges(currRange, sourceRange)
            for newRange = splitList
                if length(newRange) > 0
                    push!(splitRange, newRange)
                end
            end
        end
        global listOfSeeds2 = deepcopy(splitRange)
    end

    # println("Split List:", listOfSeeds2)

    # Now convert each range to the new range
    newListOfSeeds = []      
    for currSeedRange = listOfSeeds2
        # If no intersection is found keep the original range
        convertedRange = currSeedRange
        for sourceRange = keys(dictOfDicts[conversionNum])
            # If an intersection is found, modify the range and stop looking
            if length(intersect(currSeedRange, sourceRange)) > 0
                convertedRange = range(currSeedRange[1] - sourceRange[1] + dictOfDicts[conversionNum][sourceRange]; length = length(currSeedRange))
                break
            end
        end

        push!(newListOfSeeds, convertedRange)
    end

    # Replace the list of seeds
    global listOfSeeds2 = newListOfSeeds  
end

# Print the answer
println("Part 2 answer:", minimum(minimum((listOfSeeds2))))

