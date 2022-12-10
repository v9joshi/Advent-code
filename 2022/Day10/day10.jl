# Read inputs
inputs = read(".\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")     # Sanitize inputs
inputs = strip(inputs,'\n')           # Trailing end line is annoying
inputs = split(inputs,'\n')           # Split into lines

# Initialize input
X = 1
storeX = []
imgCRT = ""

# Run the commands
for command in inputs
    # If pixel positions equal the currently drawn pixel then add a # else add a .
    addCRT = (mod(length(storeX),40) in X-1:X+1 ? "#" : ".")

    # In all cases push the value of X into the store
    push!(storeX, X)

    # If adding, change the value of X and then push the new value in
    if occursin("addx",command)
        # If pixel positions equal the currently drawn pixel then add a # else add a .
        global addCRT = addCRT*(mod(length(storeX),40) in X-1:X+1 ? "#" : ".")
        
        # After changing CRT execute the command
        numVal = parse(Int, split(command," ")[2])

        global X = X + numVal
        push!(storeX,X)
    end

    global imgCRT = imgCRT*addCRT
end

# Find the value of interest
sigStrength = []

for sigIdx = 20:40:220
    push!(sigStrength, sigIdx*storeX[sigIdx])
end

# Split the CRT image into rows
imgCRT = reduce(vcat, map(x -> imgCRT[((x - 1)*40 + 1):(x*40)], 1:6))

# Print the result
println("Requested sum = ", sum(sigStrength))
println("CRT image:")
println.(imgCRT)
