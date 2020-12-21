import re
from itertools import combinations, product
import math

# Read the data
f = open('input.txt')
#f = open('testInput.txt')
raw = f.read()
foodBlocks = raw.split('\n')

# Store the tiles in a dict
allergenDict = {}
allIngredients = []

# Go through each line from the raw data
for food in foodBlocks:
    # Sanitize inputs, could use regex but is hard
    food = food.replace("(contains",":")
    food = food.replace(")","")
    food = food.replace(",","")

    #print(food)
    # Check for empty lines. If not empty split into ingredient and allergen
    if food:
        ingredientList, allergenList = food.split(":")
    # If empty continue the for loop
    else:
        continue

    # Split the strings into separate entries for a list
    allergenList = [allergen for allergen in allergenList.split(" ") if allergen]
    ingredientList = [ingredient for ingredient in ingredientList.split(" ") if ingredient]

    # For each allergen, make an entry in the dict
    for allergen in allergenList:
        # If the allergen is already in the dict, only keep common entries
        if allergen in allergenDict.keys():
            allergenDict[allergen] = allergenDict[allergen].intersection(ingredientList)
        # If the allergen is new, make an entry in the dict with all ingredients
        else:
            allergenDict[allergen] = set(ingredientList)

    # Make a list of each ingredient, keep copies for repetitions
    allIngredients.extend(ingredientList)

# Find the allergen ingredients
allergenIngredients = set()
# For each allergen in the dict, ingredients corresponding to it are stored
for allergen in allergenDict.keys():
    allergenIngredients.update(allergenDict[allergen])

# Safe ingredients are ingredients that don't occur with any allergens
safeIngredients = [ingredient for ingredient in allIngredients if not ingredient in allergenIngredients]

#print("All ingredients: ", allIngredients)
#print("Safe ingredients: ", safeIngredients)
# First half
print("First half")
print("Number of times safe ingredients are present: ", len(safeIngredients))

# Second half
# Clean the allergen dict to remove repetitions
usedIngredients = set()

# Keep going till all the allergen ingredients are used
while not allergenIngredients.issubset(usedIngredients):
    # Check each allergen to find possible ingredients for it
    for allergen in allergenDict.keys():
        # If there is more than one ingredient, remove the used ones
        if len(allergenDict[allergen]) > 1:
            allergenDict[allergen] = allergenDict[allergen] - usedIngredients
        # If there is one ingredient, add it to the used ingredients
        else:
            #print(allergenDict[allergen])
            usedIngredients = usedIngredients.union(allergenDict[allergen])
            allergenDict[allergen] = list(allergenDict[allergen])

print("Second half")
print("Canonical dangerous ingredient list", end = ": ")

# Sort the keys store the ingredients
cannonicalIngredients = []
for allergen in sorted(allergenDict.keys()):
    cannonicalIngredients.append(allergenDict[allergen][0])

print(",".join(cannonicalIngredients))
