# Read inputs
inputs = read(".\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")         # Sanitize inputs
inputs = strip(inputs,'\n')               # Trailing end line is annoying
inputs = split(inputs, '\n')              # Split into lines

# Make a set with all the blocks
lavaBlocks = Set()
for block in inputs
    (x,y,z) = parse.(Int,split(block,","))

    push!(lavaBlocks, CartesianIndex(x,y,z))
end

# Find surface area
function surfArea(blocks)
    # Start with 6 faces for each block
    surfaceArea = 6*length(blocks)

    # Define adjacent blocks
    adjBlocks = [CartesianIndex(-1, 0, 0),CartesianIndex( 1, 0, 0),
                 CartesianIndex( 0,-1, 0),CartesianIndex( 0, 1, 0),
                 CartesianIndex( 0, 0,-1),CartesianIndex( 0, 0, 1)]

    # If an adjacent block is filled with lava then it won't be cooled
    for block in blocks
        numBlocked = [1 for Δ in adjBlocks if block + Δ in blocks] |> sum
        surfaceArea = surfaceArea - numBlocked
    end

    return surfaceArea
end

println("Surface area #1 = ", surfArea(lavaBlocks))

# Find surface area #2
(minX, minY, minZ) = Tuple(minimum(lavaBlocks))
(maxX, maxY, maxZ) = Tuple(maximum(lavaBlocks))

println("X: ", (minX,maxX), " Y:", (minY,maxY), " Z:", (minZ,maxZ))
# Add water
waterBlocks   = Set()
visitedBlocks = Set()
newBlocks     = [CartesianIndex.(minX-1,   minY,   minZ)]
push!(waterBlocks, newBlocks...)

# Get all the adjacent water blocks
adjBlocks = [CartesianIndex(-1, 0, 0),CartesianIndex( 1, 0, 0),
             CartesianIndex( 0,-1, 0),CartesianIndex( 0, 1, 0),
             CartesianIndex( 0, 0,-1),CartesianIndex( 0, 0, 1)]

while length(newBlocks) > 0 
    # Empty the new blocks
    global newBlocks = []

    # Check all the blocks in the volume
    for (x,y,z) in Iterators.product(minX-1:maxX+1, minY-1:maxY+1, minZ-1:maxZ+1)
        block = CartesianIndex(x,y,z)

        # println(block, " is being tested")
        # If the block is lava or water skip it
        if block ∈ lavaBlocks || block ∈ waterBlocks
            continue
        # If the block is adjacent to water then make it water
        else
            for Δ in adjBlocks
                if block + Δ ∈ waterBlocks
                    # println(block + Δ, " is water")
                    push!(waterBlocks, block)
                    push!(newBlocks, block)
                    break
                end
            end
        end
    end
end

# New surf area function
function surfArea(blocks, water)
    surfaceArea = 0

    # Define adjacent blocks
    adjBlocks = [CartesianIndex(-1, 0, 0),CartesianIndex( 1, 0, 0),
                 CartesianIndex( 0,-1, 0),CartesianIndex( 0, 1, 0),
                 CartesianIndex( 0, 0,-1),CartesianIndex( 0, 0, 1)]

    # If an adjacent block is filled with lava then it won't be cooled
    for block in blocks
        numCooled = [1 for Δ in adjBlocks if block + Δ in water] |> sum
        surfaceArea = surfaceArea + numCooled
    end

    return surfaceArea
end


println("Surface area #2 = ", surfArea(lavaBlocks, waterBlocks))