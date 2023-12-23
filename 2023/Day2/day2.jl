inputs = read(".\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")     # Sanitize inputs
inputs = strip(inputs,'\n')           # Trailing end line is annoying

# Split the input into lines
inputLines = split.(inputs,'\n')

# How many balls are there at most?
numBalls = Dict("red" => 12, "green" => 13, "blue" => 14)

# Initiate the sum of possible games and the total power
gameSum  = 0
powerSum = 0

# Read each line one at a time
for line = inputLines
    # Is the game possible?
    gamePossible = true

    # Split the line into game info and draw info
    lineInfo = split(line, ':')
    
    # Find the game number
    gameNum = parse(Int,join([filter(isdigit, lineInfo[1])]))

    # Now look at each draw
    maxNum = Dict("red" => 0, "green" => 0, "blue" => 0)
    for draw = split(lineInfo[2],';')
        # Count the number of red green and blue balls in the draws
        for ballInfo = split(draw, ',')
            if contains(ballInfo,"red")
                numDrawn = parse(Int,join([filter(isdigit, ballInfo)]))
                colDrawn = "red"
            elseif contains(ballInfo,"blue")
                numDrawn = parse(Int,join([filter(isdigit, ballInfo)]))
                colDrawn = "blue"
            elseif contains(ballInfo,"green")
                numDrawn = parse(Int,join([filter(isdigit, ballInfo)]))
                colDrawn = "green"
            end

            # Check if this is possible
            if numDrawn > numBalls[colDrawn]
                gamePossible = false
            end

            # Check if this is larger than the previous best
            if numDrawn > maxNum[colDrawn]
                maxNum[colDrawn] = numDrawn
            end
        end
    end

    # Update the game sum
    if gamePossible
        global gameSum = gameSum + gameNum
    end

    # Update the total power
    global powerSum = powerSum + (values(maxNum) |> prod)

    print(gameNum, " is ", gamePossible, "\n")
end

# Print the result for part #1
print("Part 1 Game sum is: ", gameSum, "\n")
print("Part 2 Game product is: ", powerSum, "\n")