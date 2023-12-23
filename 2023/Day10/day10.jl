inputs = read(".\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")     # Sanitize inputs
inputs = strip(inputs,'\n')           # Trailing end line is annoying

# Split into lines
inputLines = split(inputs,'\n')

# Use the input to make a map
inputMap = reduce(vcat, permutedims.(collect.(inputLines))) 
mapHeight = size(inputMap, 1)
mapWidth  = size(inputMap, 2)

# Dictionary of symbols
# | is a vertical pipe connecting north and south.
# - is a horizontal pipe connecting east and west.
# L is a 90-degree bend connecting north and east.
# J is a 90-degree bend connecting north and west.
# 7 is a 90-degree bend connecting south and west.
# F is a 90-degree bend connecting south and east.
# . is ground; there is no pipe in this tile.
# S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.

# Make a dictionary to tell you where you're going next
pipeDict = Dict()
pipeDict['|'] = f1(x) = (x == 'N' ? 'N' : (x == 'S' ? 'S' : 0))
pipeDict['-'] = f2(x) = (x == 'E' ? 'E' : (x == 'W' ? 'W' : 0))
pipeDict['L'] = f3(x) = (x == 'S' ? 'E' : (x == 'W' ? 'N' : 0))
pipeDict['J'] = f4(x) = (x == 'E' ? 'N' : (x == 'S' ? 'W' : 0))
pipeDict['7'] = f5(x) = (x == 'N' ? 'W' : (x == 'E' ? 'S' : 0))
pipeDict['F'] = f6(x) = (x == 'N' ? 'E' : (x == 'W' ? 'S' : 0))

headingDict = Dict()
headingDict['N'] = CartesianIndex((-1, 0))
headingDict['S'] = CartesianIndex(( 1, 0))
headingDict['E'] = CartesianIndex(( 0, 1))
headingDict['W'] = CartesianIndex(( 0,-1))


# Follow the maze
# startPosition = indexin('S',inputMap)[1]
loopLength = Dict()
loopPath   = Dict()
for startHeading = ['N','E','W','S']
    startPosition = indexin('S',inputMap)[1]

    numSteps = 0
    global loopPath[startHeading] = Vector{Vector{Int64}}([])
    currentPosition = startPosition
    currentHeading = startHeading
    println("Start heading: ", startHeading)
    while true
        numSteps = numSteps + 1
        # println("CurrPos: ", currentPosition)
        # println("CurrHeading: ", currentHeading)
        # println("PosChange: ", headingDict[currentHeading])
        newPosition = currentPosition + headingDict[currentHeading]
       
        # Check that the new position is valid
        if  !((0 < newPosition[1] <= mapHeight) && (0 < newPosition[2] <= mapWidth))
            println("Heading out of bounds")
            break
        end

        append!(loopPath[startHeading],[[newPosition[1], newPosition[2]]])

        # println("newPos: ", newPosition)
        # What's the pipe in the new position
        newPipe = inputMap[newPosition]
        # println("Pipe at new pos: ", newPipe)

        if newPipe == 'S'
            println("Loop complete")
            loopLength[startHeading] = numSteps
            println("Loop length: ", loopLength)
            break
        elseif newPipe == '.'
            println("Not connected")
            break
        end
                
        # How does this new pipe change the heading?
        newHeading = pipeDict[newPipe](currentHeading)

        # Check if we've found a non-connecting pipe
        if newHeading == 0
            println("Not connected")
            break
        end
        
        # Update the position and heading
        currentHeading  = newHeading
        currentPosition = newPosition

        # println("New heading: ", newHeading)
    end
end

# Answer to part 1
println("Max distance from start: ", sum(values(loopLength))/4)

# Some Greens theorem stuff that I don't quite understand
function Displacements(loop::Vector{Vector{Int64}})
	"""Line elements dℓ for integral."""
	ℓ = length(loop)
	map(n -> loop[mod(n, ℓ) + 1] - loop[n], 1:ℓ)
end

function VectorField(loop::Vector{Vector{Int64}}, α::Float64)
	"""A vector field on the loop whose curl is constant and
	points out of the plane.

	We are free to choose any field indexed by α∈[0,1] since it
	doesn't change the curl.
	"""
	map(p -> α*[-p[2], 0] + (1 - α)*[0, +p[1]], loop)
end

function InteriorArea(loop::Vector{Vector{Int64}}, α::Float64)
	"""Interior area of the loop.

	By construction, the curl of the vector field is 1 and out of
	the plane. Stokes' theorem allows us to express the area as a
	line integral of the field around the loop."""
	V, dℓ = VectorField(loop, α), Displacements(loop)
	mapreduce(n -> (V[n][1]*dℓ[n][1] + V[n][2]*dℓ[n][2]), +, 1:length(loop))
end

function EnclosedTiles(loop::Vector{Vector{Int64}}, α::Float64=0.5)
	"""Tiles interior to the loop.

	To correct for the boundary we use a variant of Pick's
	theorem.
	"""
	ℓ, A = length(loop), abs(InteriorArea(loop, α))
	round(Int64, A - ℓ/2 + 1)
end

enclosed = EnclosedTiles(loopPath['N'], rand(Float64))
println("enclosed area: ", enclosed)