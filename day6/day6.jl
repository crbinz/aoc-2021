using DelimitedFiles 

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

for i = 1:80
    step!(fish) 
end

println("Part 1:")
println(length(fish))
