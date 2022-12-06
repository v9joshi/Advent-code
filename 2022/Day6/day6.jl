# Read inputs
inputs = read(".\\testInput.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")         # Sanitize inputs
inputs = strip(inputs,'\n')               # Trailing end line is annoying

inputs = split(inputs,"\n")               # If there are multiple messages, split them

# Make a function to find the index at which nUnique characters in the signal are all unique for the first time
function StartPoint(nUnique, signal)
    # Break this into characters
    signal = split(signal,"")

    # Read the signal n characters at a time till all n characters are unique
    marker = findfirst(isequal(nUnique),map(x -> length(unique(signal[x:x+nUnique-1])),1:length(signal)-nUnique+1))

    return marker + nUnique-1
end

# Look for start markers and message markers
for currInput in inputs   
    println("Start Marker = ", StartPoint(4,currInput))
    println("Message Marker = ", StartPoint(14,currInput))
end