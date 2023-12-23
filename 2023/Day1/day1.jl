inputs = read(".\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")     # Sanitize inputs
inputs = strip(inputs,'\n')           # Trailing end line is annoying

# Split the input into lines
inputLines = split.(inputs,'\n')

# Part 1 find the first and last digit in a line
# Get all the numbers in each line
numbersInLine = [filter(isdigit, collect(s)) for s in inputLines]
numbersInLine = map((ele) -> parse.(Int, ele), numbersInLine)

valueInLine  = [num[1]*10 + num[end] for num in numbersInLine]

# Print the answer
print("Part 1 Sum of calibration values:", sum(valueInLine))

# Part 2 some numbers written as words
# Important to put the number in without removing the letters because
# eightwo counts as 82, not 8wo or eigh2
wordToNumDict = Dict("one" => "one1one","two" => "two2two",
                      "three" => "three3three","four" => "four4four",
                      "five" => "five5five","six" => "six6six",
                      "seven" => "seven7seven","eight" => "eight8eight",
                      "nine" => "nine9nine")

# Sequentially replace each key with corresponding value
for numWord = keys(wordToNumDict)
    global inputLines = map((line) -> replace(line, numWord => wordToNumDict[numWord]), inputLines)
end

# Get all the digits in each line
numbersInLine = [filter(isdigit, collect(s)) for s in inputLines]
numbersInLine = map((ele) -> parse.(Int, ele), numbersInLine)

valueInLine  = [num[1]*10 + num[end] for num in numbersInLine]

# Print the answer
print("Part 2 Sum of calibration values:", sum(valueInLine))
