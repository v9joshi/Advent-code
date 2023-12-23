inputs = read(".\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")     # Sanitize inputs
inputs = strip(inputs,'\n')           # Trailing end line is annoying

# Split the input into lines
inputLines = split.(inputs,'\n')

# How many points do you have?
totalPoints = 0
cardWins    = Dict()

# Find the points won on each card
for card = inputLines
    cardInfo = split(card,':')
    cardNum  = parse(Int,join([filter(isdigit, cardInfo[1])]))


    # Split the pair of numbers
    numInfo  = split(cardInfo[2],'|')

    # What are the winning numbers?
    winningNums = parse.(Int, map(x -> numInfo[1][x], findall(r"(\d+)", numInfo[1])))
    
    # What numbers do you have?
    yourNums    = parse.(Int, map(x -> numInfo[2][x], findall(r"(\d+)", numInfo[2])))

    # How many matches did you get?
    numWins = 0

    for checkNum = yourNums
        if checkNum in winningNums
            numWins = numWins + 1
        end
    end

    # Convert matches into points
    global totalPoints = totalPoints + (numWins > 0 ? 2^(numWins-1) : 0)

    # How many wins for each card number?
    global cardWins[cardNum] = numWins
end

# Answer to part 1
print("Part 1:", totalPoints, "\n")

# Part 2 How many cards do you end with? Recursion time
numCards = length(keys(cardWins))
numAdded = Dict()

# Recursively calculate how many additional cards each card wins. Use a hash table to make life easier
function calcCards(cardNum, cardWins, numAdded)
    if cardNum in keys(numAdded)
        # Do nothing
        # print("Card ", cardNum," was already calculated and it adds ", numAdded[cardNum], " additional cards \n")
    else
        if cardWins[cardNum] > 0
            # print("Card ", cardNum," hasn't been calculated yet, calculating recursively \n")
            numAdded[cardNum] = map(x -> ((cardNum + x) in keys(cardWins)) ? (1 + calcCards(cardNum + x, cardWins, numAdded)) : 0, 1:cardWins[cardNum]) |> sum
            # print("Card ", cardNum," was just calculated, and it wins ", numAdded[cardNum], " additional cards \n")
        else
            numAdded[cardNum] = 0
            # print("Card ", cardNum," doesn't win anything \n")
        end
    end

    return numAdded[cardNum]
end

# Calculate the number of cards added by each card
for card = 1:length(keys(cardWins))
    if calcCards in keys(numAdded)
        continue
    else
        calcCards(card, cardWins, numAdded)
    end
end

# What's the total number of cards?
numCards = numCards + sum(values(numAdded))
print("Part 2:", numCards, "\n")