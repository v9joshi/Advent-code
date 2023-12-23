inputs = read(".\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")     # Sanitize inputs
inputs = strip(inputs,'\n')           # Trailing end line is annoying

# Split the input into sections
inputLines = split(inputs,"\n")

# Read the lines one at a time and find what number comes next
nextNumList = []
prevNumList = []

for line = inputLines
    # Parse the line to get the numbers
    nums = parse.(Int, split(line,' '))

    # What is the current list of numbers?
    currNums = nums

    # Find the next number and the previous number
    nextNum = nums[end]
    prevNum = nums[1]
    sign    = -1

    while !(all(currNums .== 0))
        currNums = diff(currNums)
        nextNum  = nextNum + currNums[end]
        prevNum  = prevNum  + sign*currNums[1]
        sign = sign*-1
    end

    # Store the new number
    append!(nextNumList, nextNum)
    append!(prevNumList, prevNum)
end

# Answer to pt1
println("Answer pt 1: ", sum(nextNumList))
println("Answer pt 2: ", sum(prevNumList))