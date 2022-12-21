# Read inputs
inputs = read(".\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")     # Sanitize inputs
inputs = strip(inputs,'\n')           # Trailing end line is annoying
inputs = split(inputs,"\n")           # Split into lines

# Make a function to evaluate a command based on given operation and input numbers
function runEq(val1, op, val2)
    # op contains +,-,*,/
    if op == "+"
        return val1 + val2
    elseif op =="-"
        return val1 - val2
    elseif op == "*"
        return val1*val2
    elseif op == "/"
        return val1/val2
    end
end

# Make a function to parse all the commands and run them
function findRoot(inputList, guessValue)
    # Make a dict of all the variables
    valueDict = Dict()

    # Set the value of the humn variable
    if !isnan(guessValue)
        # println("set the value")
        valueDict["humn"] = guessValue
    else
        # println("don't set the value")
    end

    # Now loop through all the commands till they're solved
    while true
        for command in inputList
            # Split into lhs and rhs
            (lhs, rhs) = split(command, ": ")

            # If command depends on variables, split to form the equation
            if length(rhs) == 11
                (var1,op,var2) = split(rhs, " ")
                # println(var1, " --- ", op, " --- ", var2)
                try    
                    valueDict[lhs] = runEq(valueDict[var1], op, valueDict[var2])
                catch
                end
            # Otherwise set the variable value
            else
                try
                    valueDict[lhs] = parse(Int, rhs)
                catch
                end
            end
        end

        # If possible, return the root value
        try
            return valueDict["root"]
        catch
        end
    end
end

# Part 1
println(findRoot(inputs, NaN))

# Part 2
inputs2 = []
# First we change the function call in root
for command in inputs
    if contains(command,"root")
        command = replace(command, "+" => "-")
    elseif contains(command, "humn:")
        continue
    end

    push!(inputs2, command)
end

# Lets use some gradient descent
guess1 = 10000
guess2 = -10000

res1 = findRoot(inputs2, guess1)
res2 = findRoot(inputs2, guess2)

# Keep looping till we get the solution
while true
    # Print the result
    println(guess1, " -> ", res1)
    println(guess2, " -> ", res2)

    # Check if sol is found
    if res2 == 0
        println("Sol = ", guess2)
        break
    elseif res1 == 0
        println("Sol = ", guess1)
        break
    end

    # Now we update the guesses
    Δ = (guess2 - guess1)/(res2 - res1)
    
    # Determine which guess to update
    if abs(res1) < abs(res2)
        global guess2 = guess1 - Δ*res1
        global res2   = findRoot(inputs2, guess2)
    else
        global guess1 = guess2 - Δ*res2
        global res1   = findRoot(inputs2, guess1)
    end
end