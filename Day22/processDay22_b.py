import re

# Read the data
f = open('input.txt')
#f = open('testInput.txt')
raw = f.read()
deckBlocks = raw.split('\n\n')

# Get first deck
deck1 = deckBlocks[0].split('\n')
deck1 = deck1[1:]

# Get second deck
deck2 = deckBlocks[1].split('\n')
deck2 = deck2[1:-1]

# Create a dictionary with the game history
gameHistory = {}
gameHistory[1] = []
gameHistory[2] = []

# Define a round of recursive combat
def roundCombat(subDeck1, subDeck2):
    # Get the cards
    card1 = subDeck1.pop(0)
    card2 = subDeck2.pop(0)
    # print(card1, card2)
    # print(len(subDeck1), len(subDeck2))

    # Check if the number of cards left in the deck fails the required rule
    if (int(card1) > len(subDeck1)) or (int(card2) > len(subDeck2)):
        # If it fails then the winner is the person with the bigger card
        if int(card1) > int(card2):
            return 1
        else:
            return 2
    # If rule is met then play a new game of recursive combat
    else:
        # print('play a sub-game')
        newDeck1 = subDeck1[0:int(card1)]
        newDeck2 = subDeck2[0:int(card2)]
        # print(newDeck1, newDeck2)
        # This new game has no history since it has never been played
        gameHistory = {}
        gameHistory[1] = []
        gameHistory[2] = []
        subGameWinner = gameCombat(newDeck1.copy(), newDeck2.copy(), gameHistory)
        return subGameWinner

# This is a game of recursive combat
# Keep playing till a deck runs, a deck is too small or
# deck order exists in game history
def gameCombat(deck1, deck2, gameHistory):
    while deck1 and deck2:
        # print(deck1, deck2)
        # print(gameHistory)
        # If this exact deck order has happened before, player 1 wins
        if deck1 in gameHistory[1] and deck2 in gameHistory[2]:
            return 1
        # Otherwise, play a round
        else:
            # Call the round function
            # print('play a new round')
            winner = roundCombat(deck1.copy(), deck2.copy())
            # print('round winner', winner)
            # Add the decks to the game history
            gameHistory[1].append(deck1.copy())
            gameHistory[2].append(deck2.copy())

            # Draw the cards
            card1 = deck1.pop(0)
            card2 = deck2.pop(0)

            # If player 1 won the round
            if winner == 1:
                deck1.extend([card1, card2])
            # If player 2 won the round
            elif winner == 2:
                deck2.extend([card2, card1])

    #If deck 1 is empty, 2 wins
    if not deck1:
        return 2
    # If deck 2 is empty, 1 wins
    elif not deck2:
        return 1

# Let's play recursive combat
winner = gameCombat(deck1, deck2, gameHistory)

# Find the winning deck
if winner == 1:
    winnerDeck = deck1
else:
    winnerDeck = deck2

#print(gameHistory)

# Find the score of the winning deck
deckScore = 0
winnerDeck = deck1 + deck2

# print(winnerDeck)
for cardNum, cardVal in enumerate(winnerDeck):
    deckScore = deckScore + (len(winnerDeck) - cardNum)*int(cardVal)

# Print the result
print('second half')
print('The score of the winning deck is: ', deckScore)
