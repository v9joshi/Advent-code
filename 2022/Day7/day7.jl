# Read inputs
inputs = read(".\\input.txt", String) # Read all the inputs
inputs = replace(inputs,'\r'=>"")         # Sanitize inputs
inputs = strip(inputs,'\n')               # Trailing end line is annoying
inputs = split(inputs,"\n")               # Split into lines

# Make a Node struct
mutable struct Node
    path::String
    size::Int
    children
    parent
    visitedChildren
end

function correctFolderSize(folderName, dirMap)
    # Get the current file size
    fileSize = folderName.size

    # Add the file size of each child folder
    while length(folderName.children) > 0 
        currChild = dirMap[popfirst!(folderName.children)]
        fileSize = fileSize + correctFolderSize(currChild, dirMap)
        push!(folderName.visitedChildren, currChild)
    end

    # Correct the file size
    folderName.size = fileSize

    # Return the file size
    return fileSize
end

# Make a list of all the directories
currDir = "root"
dirMap  = Dict()

while length(inputs) > 0
    command = popfirst!(inputs)
    # Change directory
    if occursin("\$ cd",command)
        targetDir = split(command," ")[3]

        #println(targetDir)
        # If new directory is "/" then join will take care of adding the "/"
        if targetDir == "/"
            global dirMap["root"] = Node("root",0,[],[],[])
            continue
        elseif targetDir == ".."
            global currDir = dirMap[currDir].parent
        else
            newPath = currDir*"/"*targetDir
            global currDir = newPath
        end

    # List contents
    elseif occursin("\$ ls",command)
        # Keep popping till dir is finished listing
        while !occursin('\$',inputs[1])
            currEle = popfirst!(inputs)

            # Check if dir
            if occursin("dir", currEle)
                dirName = split(currEle," ")[2]
                newPath = currDir*"/"*dirName
                global dirMap[newPath] = Node(newPath, 0, [], currDir, [])
                # println(keys(dirMap))
                push!(dirMap[currDir].children, newPath)
            else
                fileSize = parse(Int,split(currEle," ")[1])
                global dirMap[currDir].size = dirMap[currDir].size + fileSize
            end

            # Terminate if we run out of inputs
            if length(inputs) == 0
                break
            end
        end
    end
end

# Correct the folder size of the root folder
correctFolderSize(dirMap["root"],dirMap)

# Find the folder sizes above some threshold and add them up
threshold1 = 100000
threshold2 = dirMap["root"].size - 40000000
totalSize  = 0
deletedDir = "root"

for keyName in keys(dirMap)
    # Get the size of the current directory
    currSize = dirMap[keyName].size
    println(keyName, " ", currSize)

    if currSize < threshold1
        global totalSize = totalSize + currSize
    end

    if currSize > threshold2 && currSize < dirMap[deletedDir].size
        global deletedDir = keyName
    end
end

println("Total requested size = ", totalSize)
println("File to delete = ", deletedDir, " Size = ", dirMap[deletedDir].size)
