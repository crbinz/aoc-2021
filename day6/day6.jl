using DelimitedFiles, ProgressBars

mutable struct Lanternfish
    timer::Int64
end

function parse_inputs(fn::String)
    inputs = readdlm(fn,',',Int64)

    fish = Vector{Lanternfish}(undef,length(inputs))

    for i in 1:length(inputs)
        fish[i] = Lanternfish(inputs[i])
    end
    return fish
end

function step!(allfish::Vector{Lanternfish})
    newfish = Vector{Lanternfish}(undef,0)
    for i in 1:length(allfish)
        if allfish[i].timer == 0 # birth another fish
            push!(newfish,Lanternfish(8))
            allfish[i].timer = 6
        else
            allfish[i].timer = allfish[i].timer - 1
        end
    end
    append!(allfish,newfish)
end

#fish = parse_inputs("test-input.txt")
fish = parse_inputs("input.txt")

lengths = zeros(80)

for i = 1:80
    step!(fish) 
    lengths[i] = length(fish)
end

println("Part 1:")
println(length(fish))

function step!(fishnumbers::Vector{Int64})
    oldnumbers = copy(fishnumbers)
    # 1
    fishnumbers[2] = oldnumbers[3]
    # 2
    fishnumbers[3] = oldnumbers[4]
    # 3
    fishnumbers[4] = oldnumbers[5]
    # 4
    fishnumbers[5] = oldnumbers[6]
    # 5
    fishnumbers[6] = oldnumbers[7]
    # 6
    fishnumbers[7] = oldnumbers[1] + oldnumbers[8]
    # 7
    fishnumbers[8] = oldnumbers[9]
    # 8
    fishnumbers[9] = oldnumbers[1]
    # 0
    fishnumbers[1] = oldnumbers[2]

    return fishnumbers
end

function parse_inputs_count(fn::String)
    inputs = readdlm(fn,',',Int64)

    numbers = zeros(Int64,9)

    for i in 1:9
        numbers[i] = count(inputs.==(i-1))
    end
    return numbers
end

#fishnums = parse_inputs_count("test-input.txt")
fishnums = parse_inputs_count("input.txt")

for i = 1:256
    step!(fishnums)
end

println("Part 2:")
println(sum(fishnums))
