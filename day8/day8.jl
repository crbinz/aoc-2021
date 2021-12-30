#

function parse_inputs(fn::String)

end

inputs = readlines("test-inputs.txt")
#inputs = readlines("input.txt")

notes = Vector{Vector{String}}(undef,length(inputs))

function count_easy(inputs)
    total = 0
    for i = 1:length(inputs)
        notes[i] = split(split(inputs[i],'|')[2],' ',keepempty=false)
        total = total + count(length.(notes[i]).==2 .||
                                length.(notes[i]).==3 .||
                                length.(notes[i]).==4 .||
                                length.(notes[i]).==7)
    end
    return total
end

println("Part 1:")
println(count_easy(inputs))

function process_notes(nums::Vector{String})
    ids = Vector{Int64}(undef,10)

    lengths = length.(nums)
    ids[1] = findfirst(lengths.==2)
    ids[7] = findfirst(lengths.==3)
    ids[4] = findfirst(lengths.==4)
    ids[8] = findfirst(lengths.==7)

    sixes = findall(lengths.==6)
    fives = findall(lengths.==5)

    # find 9, of which 4 is a subset
    nine = findfirst(issubset.(Ref(nums[ids[4]]),nums[sixes]))
    ids[9] = sixes[nine] # ID of the true number 9
    deleteat!(sixes,nine)

    # find 0, of which 1 is a subset
    zero = findfirst(issubset.(Ref(nums[ids[1]]),nums[sixes]))
    ids[10] = sixes[zero]
    deleteat!(sixes,zero)
    # six is the only six-digit number left
    ids[6] = first(sixes)

    three = findfirst(issubset.(Ref(nums[ids[1]]),nums[fives]))
    ids[3] = fives[three] # ID of the true number 3
    deleteat!(fives,three)

    five = findfirst(issubset.(nums[fives],Ref(nums[ids[6]])))
    ids[5] = fives[five]
    deleteat!(fives,five)

    # 2 is the last five-digit number left
    ids[2] = first(fives)

    return ids
end

function find_output(allnums::Vector{String}, digits::Vector{String})
    ids = process_notes(allnums)
    ordered_nums = allnums[ids]
    
    solution_nums = Vector{Int64}(undef,length(digits))
    for i in 1:length(digits)
        solution_nums[i] = findfirst(join(sort(collect(digits[i]))) .== join.(sort.(collect.(ordered_nums))))
        if solution_nums[i] == 10
            solution_nums[i] = 0
        end
    end
    return join(string.(solution_nums))
end

function part2(fn::String)
    inputs = readlines(fn)
    outputs = Vector{Int64}(undef,length(inputs))
    for i = 1:length(inputs)
        numbers = String.(split(split(inputs[i],'|')[1],' ',keepempty=false))
        notes = String.(split(split(inputs[i],'|')[2],' ',keepempty=false))
        outputs[i] = parse(Int64,find_output(numbers, notes))
    end
    return sum(outputs)
end
    
println("Part 2:")
println(part2("input.txt"))




