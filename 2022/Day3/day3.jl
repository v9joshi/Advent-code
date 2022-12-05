# Read inputs
inputs = read(".\\input.txt", String)     # Read all the inputs
inputs = replace(inputs,'\r'=>"")         # Sanitize inputs
inputs = strip(inputs,'\n')               # Trailing end line is annoying
inputs = split.(inputs,'\n')              # Split blocks of data into different vectors

# Split into pairs and find common element
commonItems = []
for currBag = 1:length(inputs)
    # What are the bag contents?
    bagContents = inputs[currBag]

    # How big is the bag?
    bagSize = length(bagContents)

    # How big is the compartment?
    compartmentSize = Int(bagSize*0.5)

    # Find the contents of each compartment
    firstCompartment  = bagContents[1:compartmentSize]
    secondCompartment = bagContents[1+compartmentSize:bagSize]

    # Find the common item
    for item in split(firstCompartment,"")
        if occursin(item, secondCompartment)
            push!(commonItems,item)
            break
        end
    end
end

# Print the common items list
#println("Common items ",commonItems)

# Convert to priority
priorityList = join('a':'z')*join('A':'Z')
prioritySum  = map((x) -> findfirst(x,priorityList)[1], commonItems) |> sum

println("Priority sum = ", prioritySum)

# Find all the badges
badgeItems  = []
for currBag = 1:3:length(inputs)
    # What are the bag contents?
    bag1Contents = inputs[currBag]
    bag2Contents = inputs[currBag+1]
    bag3Contents = inputs[currBag+2]

    # Find the common item
    for item in split(bag1Contents,"")
        if occursin(item, bag2Contents) & occursin(item, bag3Contents)
            push!(badgeItems,item)
            break
        end
    end
end

# Convert to priority
badgeSum  = map((x) -> findfirst(x,priorityList)[1], badgeItems) |> sum

println("Badge sum = ", badgeSum)
