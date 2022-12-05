inputs = read(".\\input.txt", String)     # Read all the inputs
inputs = replace(inputs,'\r'=>"")         # Sanitize inputs
inputs = strip(inputs,'\n')               # Trailing end line is annoying
inputs = split.(inputs,'\n')              # Split blocks of data into different vectors

# Parse and store mine and the opponents plays
matchThrows = []

for currMatch = 1:length(inputs)
    currMatchThrows = split(inputs[currMatch],' ')
    push!(matchThrows, (currMatchThrows[1], currMatchThrows[2]))
end

# Make a dict of scores for inputs
rpsDict1 = Dict(("A","X") => 4,("B","Y") => 5, ("C","Z") => 6,
                ("A","Y") => 8,("B","Z") => 9, ("C","X") => 7,
                ("A","Z") => 3,("B","X") => 1, ("C","Y") => 2)

rpsDict2 = Dict(("A","X") => 3,("B","Y") => 5, ("C","Z") => 7,
                ("A","Y") => 4,("B","Z") => 9, ("C","X") => 2,
                ("A","Z") => 8,("B","X") => 1, ("C","Y") => 6)

# Find the score
totScore1 = 0
totScore2 = 0

for currMatch = 1:length(inputs)
    # print("\n",matchThrows[currMatch])
    global totScore1 = totScore1 + rpsDict1[matchThrows[currMatch]]
    global totScore2 = totScore2 + rpsDict2[matchThrows[currMatch]]
end

print("Total score 1 = ", totScore1, '\n')
print("Total score 2 = ", totScore2)

