inputs = parse.(Int64,split(read("input.txt",String)))

# part 1
println(count(diff(inputs).>0))

# part 2
windowed_sums = [sum(inputs[i:i+2]) for i in 1:length(inputs)-1]

println(count(diff(windowed_sums).>0))
