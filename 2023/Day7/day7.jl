inputs = read(".\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")     # Sanitize inputs
inputs = strip(inputs,'\n')           # Trailing end line is annoying

# Split the input into lines
inputLines = split(inputs,"\n")

# Function to determine the type of hand
function handType(handInput)
    # Find the unique cards in the hand and how often they occur
    handInput = split(handInput,"")
    numCards = [count(i -> i == card, handInput) for card in unique(handInput)]

    # Based on number of occurences, find the hand type
    sortedOcc = sort(values(numCards), rev=true)

    # Conditional
    if sortedOcc[1] == 5
        return 7
    elseif sortedOcc[1] == 4
        return 6
    elseif (sortedOcc[1] == 3) && (sortedOcc[2] == 2)
        return 5
    elseif sortedOcc[1] == 3
        return 4
    elseif (sortedOcc[1] == 2) && (sortedOcc[2] == 2)
        return 3
    elseif sortedOcc[1] == 2
        return 2
    else
        return 1
    end
end

function handType2(handInput)
    typeList = []
    for card = unique(split(handInput,""))
        currType = handType(replace(handInput, 'J'=>card))
        append!(typeList, currType)
    end

    return maximum(typeList)
end

# Card score dictionary
scoreDict1  = Dict("A"=>13, "K"=>12, "Q"=>11, "J" => 10, "T" => 9, "9" => 8, "8" => 7, "7" => 6, "6" => 5, "5" => 4, "4" => 3, "3" => 2, "2" => 1)
scoreDict2 = Dict("A"=>13, "K"=>12, "Q"=>11, "T" => 10, "9" => 9, "8" => 8, "7" => 7, "6" => 6, "5" => 5, "4" => 4, "3" => 3, "2" => 2, "J" => 1)

# Assign a score to each hand based on the card order
function cardScore(handInput, scoreDict)
    cardVal = 0

    # Score each card then multiply by 13 then add the next
    for card = split(handInput,"")
        cardVal = cardVal*13 + scoreDict[card]
    end

    return cardVal
end

# Score all hands
handScore = reshape([], 0, 2)
for line = inputLines
    (hand, bet) = split(line, ' ')
    bet = parse(Int, bet)

    # What's the value of the hand
    handValue = handType2(hand)*10^6 + cardScore(hand, scoreDict2)
    global  handScore = vcat(handScore, [bet, handValue]')
end

# Sort the hands
handScore = handScore[sortperm(handScore[:,2]), :]

println(handScore)

# What's the resulting total
totalVal = 0
for (pos, bet) = enumerate(handScore[:,1])
    global totalVal = totalVal + bet*pos
end

print(totalVal)
