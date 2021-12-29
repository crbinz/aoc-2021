#

function parse_inputs(fn::String)

end

#inputs = readlines("test-inputs.txt")
inputs = readlines("input.txt")

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
