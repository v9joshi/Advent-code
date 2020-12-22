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

# Play the game till one deck is empty
while deck1 and deck2:
    # Get top card from both decks
    card1 = deck1.pop(0)
    card2 = deck2.pop(0)

    # Higher card deck wins both cards
    if int(card1) > int(card2):
        deck1.extend([card1, card2])
    else:
        deck2.extend([card2, card1])

# print(deck1)
# print(deck2)

# First half
# Find the score of the winning deck
deckScore = 0
winnerDeck = deck1 + deck2

# print(winnerDeck)
for cardNum, cardVal in enumerate(winnerDeck):
    deckScore = deckScore + (len(winnerDeck) - cardNum)*int(cardVal)

print('first half')
print('The score of the winning deck is: ', deckScore)
