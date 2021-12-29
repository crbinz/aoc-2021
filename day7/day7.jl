using DelimitedFiles, StatsBase, Optim

#positions = readdlm("test-input.txt",',',Int)
positions = readdlm("input.txt",',',Int)

println("Part 1:")

println(Int(sum(abs.(positions.-median(positions)))))

function cost(x, inputs)
    diffs = abs.(inputs .- x)
    total = 0
    for i = 1:length(diffs)
    total = total + sum(1:diffs[i])
    end
    return total
end

# cheating?
res = optimize(x->cost(x,positions),minimum(positions),maximum(positions))

println("Part 2")

println(Int(min(cost(floor(res.minimizer),positions),
            cost(ceil(res.minimizer),positions))))
