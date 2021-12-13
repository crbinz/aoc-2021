using DelimitedFiles

#inputs = readdlm("test_input.txt",String);
inputs = readdlm("input.txt",String);

input_matrix = Array{Int64}(undef,length(inputs),length(inputs[1]))

for i = 1:size(input_matrix)[1]
    input_matrix[i,:] = parse.(Int,collect(inputs[i]))
end

#Each bit in the gamma rate can be determined by finding the most common bit in the corresponding position of all numbers in the diagnostic report. 
function get_gamma_rate(m)
    join(Int.(most_common_bits(m)))
end

# Epsilon rate is the least common bit
function get_epsilon_rate(m)
    join(Int.(.!(most_common_bits(m))))
end


# Given a binary matrix, return a row vector of the most common bit for each column
function most_common_bits(m)
    sum(m,dims=1)./size(m)[1] .>= 0.5
end

println("Gamma rate:")
grate = get_gamma_rate(input_matrix)
println(grate)

println("Epsilon rate:")
erate = get_epsilon_rate(input_matrix)
println(erate)

println("Power level:")
println(parse(Int,"0b"*grate) * parse(Int,"0b"*erate))


function filter(m; criteria=:most)
    goodidx = collect(1:size(m,1))
    i = 1
    while length(goodidx) > 1
        crit = criteria == :most ? most_common_bits(input_matrix[goodidx,i]) : .!(most_common_bits(input_matrix[goodidx,i]))
        goodidx2 = findall(input_matrix[:,i] .== Int.(crit))
        goodidx = intersect(goodidx,goodidx2)
        i = i+1
    end
    return join(Int.(input_matrix[goodidx,:]))
end

println("Oxygen generator rating:")
o2rate = parse(Int,"0b"*filter(input_matrix,criteria=:most))
println(o2rate)

println("CO2 scrubber rating:")
co2scrubber_rate = parse(Int,"0b"*filter(input_matrix, criteria=:least))
println(co2scrubber_rate)

println("Life support rating:")
println(o2rate*co2scrubber_rate)
