# Read inputs
inputs = read(".\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")     # Sanitize inputs
inputs = strip(inputs,'\n')           # Trailing end line is annoying
inputs = split(inputs, '\n')          # Split into lines

# Make a blueprint structure
mutable struct blueprint
    costs
    score
end

# Memoized store
stateDict = Dict()
costDict  = Dict()

# Make some functions to optimize the geode cracking
function makeRobot(costs, currResources, currRobots, time)

    # How many branches do we have?
    # println(length(keys(stateDict)))

    if (currResources, currRobots, time) in keys(costDict)
        return costDict[(currResources, currRobots, time)]
    end

    # Can we reach this state with more time left?
    if (currResources, currRobots) in keys(stateDict) && stateDict[(currResources, currRobots)] > time
        return 0
    else
        global stateDict[(currResources, currRobots)] = time
    end

    # If there's no time left return current geode count
    if time ≤ 3 && currRobots[2] == 0
        return 0
    elseif time ≤ 2 && currRobots[3] == 0
        return 0
    elseif time ≤ 1 && currRobots[4] == 0
        return 0
    elseif time ≤ 0
        return currResources[4]
    end

    # List all the output geodes
    outputGeodes = [0]

    # Make a robot, 1: ore bot, 2: clay bot, 3: obsidian bot, 4: geode bot
    for robot in 1:4
        # Start with the resources we have
        newResources = deepcopy(currResources)
        currTime     = time

        # If we already have enough robots to mine the target resource then don't make more robots for it
        maxNeeded   = maximum(x[robot] for x in costs)*currTime
        maxProduced = currRobots[robot]*currTime + newResources[robot]
         
        if (maxNeeded ≤ maxProduced) && robot < 4
            continue
        end 

        # If you have the resources to make the robot then go ahead, else keep killing time till you get them
        while any(costs[robot] .> newResources) && currTime > 1
            currTime = currTime - 1
            newResources =  newResources .+ currRobots
        end

        # The robot cost gets charged
        newResources = newResources .- costs[robot]

        # You get the resources from your robots
        newResources =  newResources .+ currRobots

        # The number of robots increases
        newRobots        = deepcopy(currRobots)
        newRobots[robot] = newRobots[robot] + 1
        
        push!(outputGeodes, makeRobot(costs, newResources, newRobots, currTime - 1))
    end

    # Store the cost dict
    global costDict[(currResources, currRobots, time)] = maximum(outputGeodes)

    # Return the max number of geodes
    return maximum(outputGeodes)
end


# Read the resource requirements for each blueprint
blueprintDict = Dict()
for line in inputs
    # Get all the numbers
    values = map( x-> parse(Int,x.match), eachmatch(r"\d+",line))
    
    # Store the numbers in the dict
    # Order: oreCost, clayCost, obsCost
    currBlueprint = blueprint([[0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0], [0,0,0,0]], 0)
    currBlueprint.costs  = [[values[2],         0,         0,   0],
                            [values[3],         0,         0,   0],
                            [values[4], values[5],         0,   0],
                            [values[6],         0, values[7],   0]]

    blueprintDict[values[1]] = deepcopy(currBlueprint)
end

# Now we optimize each blueprint
for printNum in 1:3 #keys(blueprintDict)
    # What are our starting resources?
    startingResources = [0,0,0,0]

    # How many robots of each type do we have?
    startingRobots = [1,0,0,0]

    # How much time do we have?
    totalTime = 32

    # Maximize the geode count
    numGeodes = makeRobot(blueprintDict[printNum].costs, startingResources, startingRobots, totalTime)
    println(numGeodes, " ", printNum)

    # Score the blueprint
    blueprintDict[printNum].score = printNum*numGeodes

    # Empty the memoDict
    global stateDict = Dict()
    global costDict = Dict()
end

# Find the sum of all scores
println("Sum of scores = ", [blueprintDict[x].score for x in keys(blueprintDict)] |> sum)