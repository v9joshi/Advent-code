# Read inputs
inputs = read(".\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")     # Sanitize inputs
inputs = strip(inputs,'\n')           # Trailing end line is annoying
inputs = split(inputs,'\n')           # Split into blocks

# Define manhattan distance function
function distance(startPoint, endPoint)
    return abs.(startPoint .- endPoint) |> sum
end

# Read each sensor and corresponding beacon
sensorDict = Dict()
for line in inputs
    # Read the coordinates
    coords = map(x -> parse(Int,x.match), eachmatch(r"-*\d+", line))

    # Store in a dictionary
    sensorDict[(coords[1], coords[2])] = (coords[3], coords[4])
end

# For each sensor in the dictionary, find the blocked of areas in the target row
function findBlocked(targetRow, sensorDict, minX = -Inf, maxX = Inf)
    blockedSet = []
    for sensor in keys(sensorDict)
        # How far is the sensor from the closest beacon?
        distVal = distance(sensor, sensorDict[sensor])

        # Which columns would be closer than this beacon?
        if abs(sensor[2] - targetRow) > distVal
            continue
        else
            colA =  sensor[1] - (distVal - abs(sensor[2] - targetRow))
            colB =  sensor[1] + (distVal - abs(sensor[2] - targetRow))
        end

        # Bound within the limits of minX and maxX
        colA = min(max(colA, minX), maxX)
        colB = min(max(colB, minX), maxX)

        # Store the set
        push!(blockedSet, [colA, colB])
    end

    # Remove overlaps
    cleanedSet = []

    while length(blockedSet) > 0
        # Read the first element in the old group
        (colA, colB) = popfirst!(blockedSet)

        # If the clean set is empty add the region
        if length(cleanedSet) == 0
            push!(cleanedSet, [colA, colB])
        else
            # Check for overlaps
            overlap = false
            for region in cleanedSet
                # Check if subset
                if (colA ≤ region[1] && region[2] ≤ colB)
                    overlap = true
                    cleanedSet = setdiff(cleanedSet, [region])
                    break
                # Check if partial overlap
                elseif (region[1] ≤ colA ≤ region[2]) || (region[1] ≤ colB ≤ region[2])
                    colA = min(colA, region[1])
                    colB = max(colB, region[2])
                    overlap = true
                    cleanedSet = setdiff(cleanedSet, [region])
                    break
                end
            end

            # If overlap add to blocked set else add to clean set
            if overlap
                push!(blockedSet, [colA, colB])
            else
                push!(cleanedSet, [colA, colB])
            end
        end
    end

    return cleanedSet
end

# Part 1
targetRow  = 2000000
blockedSet = findBlocked(targetRow, sensorDict)

# Find the beacons on the target row
filledSet  = filter(x-> x[2] == targetRow, collect(values(sensorDict)))
filledSet  = map(x-> x[1], filledSet) |> unique

# Find the number of blocked points
blockedPoints = map(x -> (x[2] - x[1] + 1), blockedSet) |> sum
blockedPoints = blockedPoints - length(filledSet)

# What's the total number of blocked points?
println("Num blocked points = ", blockedPoints)

# Part 2
maxInd     = 4000000
minInd     = 0
tuningFreq = 0
for currRow in minInd:maxInd
    # Find all the blocked points
    currBlocked    = findBlocked(currRow, sensorDict, minInd, maxInd)
    if length(currBlocked) == 2
        viablePoints = min(currBlocked[1][2], currBlocked[2][2]) + 1: max(currBlocked[1][1], currBlocked[2][1]) - 1
    elseif length(currBlocked) == 1
        viablePoints = union([minInd:currBlocked[1][1]],[currBlocked[1][2]:maxInd])
    else
        continue
    end
        
    if length(viablePoints) == 1
        global tuningFreq = only(viablePoints)*4000000 + currRow
        break
    end
end

println("Tuning freq: ", tuningFreq)

