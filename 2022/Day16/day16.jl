# Read inputs
inputs = read(".\\testInput.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")     # Sanitize inputs
inputs = strip(inputs,'\n')           # Trailing end line is annoying
inputs = split(inputs,'\n')           # Split into lines

# Make some dicts
tunnelMap   = Dict()
pressureMap = Dict()
stepMap     = Dict()

# Read lines one at a time
for line in inputs
    # Get all the valves in this line
    valves = map(x -> x.match, (eachmatch(r"[A-Z][A-Z]", line)))

    # Make the connection map
    tunnelMap[valves[1]] = valves[2:end]

    # Store the valve release amount, and if the valve is open
    currPressure = parse(Int, match(r"\d+",line).match)
    if currPressure > 0
        pressureMap[valves[1]] = (currPressure, false)
    else
        pressureMap[valves[1]] = (currPressure, true)
    end
end

# Make functions to solve this tunnel system
# What happens when you open a valve?
function openValve(currValve, pressureMap, timeLeft)
    # If we open this valve
    newPressureMap = deepcopy(pressureMap)
    currValue      = newPressureMap[currValve]
    newPressureMap[currValve] = (currValue[1], true)
    return stepPressure(pressureMap) + nextStep(currValve, newPressureMap, timeLeft - 1) 
end

# What happens when you move to a different tunnel?
function moveTunnel(currValve, pressureMap, timeLeft)
    # Otherwise we can choose any of n tunnels to move to
    releasedPressure = []
    for nextTunnel in tunnelMap[currValve]
        push!(releasedPressure, nextStep(nextTunnel, pressureMap, timeLeft - 1))
    end

    # Return the highest of the choices
    return stepPressure(pressureMap) + maximum(releasedPressure)
end

# How much pressure is released in one step
function stepPressure(pressureMap)
    totalPressure = 0
    for valve in keys(pressureMap)
        currValue = pressureMap[valve]
        if currValue[2]
            totalPressure = totalPressure + currValue[1]
        end
    end
    return totalPressure
end

# Choose between moving and opening a valve
function nextStep(currTunnel, pressureMap, timeLeft)
    # If this step is memoized return the memo
    if (currTunnel, pressureMap, timeLeft) in keys(stepMap)
        return stepMap[(currTunnel, pressureMap, timeLeft)]
    end

    # If there's no time left nothing to return
    if timeLeft == 0
        return 0
    else
        cost1 = openValve(currTunnel, pressureMap, timeLeft)
        cost2 = moveTunnel(currTunnel, pressureMap, timeLeft)
        
        # Find the max cost
        maxCost = max(cost1, cost2)

        # Memoize
        stepMap[(currTunnel,pressureMap, timeLeft)] = maxCost

        # Return the max cost
        return maxCost
    end
end


# This thing isn't going to be super fast so prepare to wait
bestResult = nextStep("AA", pressureMap, 30)

print("Max pressure released = ", bestResult)