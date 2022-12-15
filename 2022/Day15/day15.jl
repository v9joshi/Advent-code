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

        # Remove overlaps
        testSet = [(colA, colB)]

        while length(testSet) > 0
            # Read an element in the old group
            (colA, colB) = pop!(testSet)
    
            # Check for overlaps
            overlap = false
            for (num, (cleanA, cleanB)) in enumerate(blockedSet)
                # Check if overlapping
                if max(colA, cleanA) ≤ min(colB, cleanB)
                    overlap = true
                    colA = min(colA, cleanA)
                    colB = max(colB, cleanB)
                    deleteat!(blockedSet, num)
                    break
                end
            end
    
            # If overlap add to blocked set else add to clean set
            if overlap
                push!(testSet, (colA, colB))
            else
                push!(blockedSet, (colA, colB))
            end
        end
    end
  
    return blockedSet
end

# Part 1
t = time()
targetRow  = 2000000
blockedSet = findBlocked(targetRow, sensorDict)
dt1 = time() - t

# Find the beacons on the target row
filledSet  = filter(x-> x[2] == targetRow, collect(values(sensorDict)))[:][1] |> unique
dt2 = time() - t

# Find the number of blocked points
blockedPoints = map(x -> (x[2] - x[1] + 1), blockedSet) |> sum
blockedPoints = blockedPoints - length(filledSet)
dt3 = time() - t

# What's the total number of blocked points?
println("Time taken = $dt1, $dt2, $dt3")
println("Num blocked points = ", blockedPoints)

# Part 2 version 1
# t = time()
# maxInd     = 4000000
# minInd     = 0
# tuningFreq = 0
# for currRow in minInd:maxInd
#     # Find all the blocked points
#     currBlocked    = findBlocked(currRow, sensorDict, minInd, maxInd)
#     if length(currBlocked) == 2
#         viablePoints = min(currBlocked[1][2], currBlocked[2][2]) + 1: max(currBlocked[1][1], currBlocked[2][1]) - 1
#     elseif length(currBlocked) == 1
#         viablePoints = union([minInd:currBlocked[1][1]],[currBlocked[1][2]:maxInd])
#     else
#         continue
#     end
        
#     if length(viablePoints) == 1
#         global tuningFreq = only(viablePoints)*4000000 + currRow
#         break
#     end
# end

# dt4 = time() - t
# println("Time taken = $dt4")
# println("Tuning freq: ", tuningFreq)

# Part 2 version 2
t = time()
maxInd     = 4000000
minInd     = 0
tuningFreq = 0

linesStoreA = []
linesStoreB = []
for (sx, sy) in keys(sensorDict)
    # Each sensor has 4 lines marking its detection boundary
    distVal = distance((sx, sy), sensorDict[(sx,sy)]) + 1

    # For a sensor at location sx, sy
    # These lines are given by -
    # 1. (y - sy) =  -(x - sx) + distval
    # 2. (y - sy) =  -(x - sx) - distval
    # 3. (y - sy) =   (x - sx) + distval
    # 4. (y - sy) =   (x - sx) - distval
    # Store the slope and intercept for these lines
    linesA = [(-1, sx + sy + distVal), (-1, sx + sy - distVal)]
    linesB = [(1, -sx + sy + distVal), (1, -sx + sy - distVal)]

    # Add this to the set of lines we already have
    append!(linesStoreA, linesA)
    append!(linesStoreB, linesB)
end

# Find the points of intersection for these lines
intersectionPoints = []
for (line1, line2) in Iterators.product(linesStoreA,linesStoreB)
    # Two lines with y = m1*x + c1 and y = m2*x + c2, intersect at
    # y = (m1*c2 - m2*c1)/(c2 - c1) and x = (c2 - c1)/(m1 - m2) 
    currX = (line2[2] - line1[2])/(line1[1] - line2[1])
    currY = currX*line2[1] + line2[2]

    # Append this point to the list
    if (0 ≤ currX ≤ maxInd) && (0 ≤ currY ≤ maxInd) && isinteger(currX) && isinteger(currY)
        push!(intersectionPoints, (currX, currY))
    end
end

# Check these points to see if any of them are the right point
for point in intersectionPoints
    detectable = true

    for sensor in keys(sensorDict)
        detectableBySensor  = distance(sensor, point) > distance(sensor,sensorDict[sensor])
        
        if detectableBySensor
            detectable = true
        else
            detectable = false
            break
        end
    end

    if detectable
        global tuningFreq = point[1]*4000000 + point[2]
    end        
end

# Print the answer
dt4 = time() - t
println("Time taken = $dt4")
println("Tuning freq: ", tuningFreq)