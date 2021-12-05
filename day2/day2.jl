inputs = split.(split(read("input.txt",String),'\n'),' ')

horizontal_position = 0; depth = 0;

for ii in inputs
    if ii[1] == "forward"
        horizontal_position += parse(Int64,ii[2])
    elseif ii[1] == "up"
        depth -= parse(Int64,ii[2])
    elseif ii[1] == "down"
        depth += parse(Int64,ii[2])
    end
end

println("Part 1:")
println(horizontal_position*depth)

# part 2

horizontal_position = 0; depth = 0; aim = 0

for ii in inputs
    if ii[1] == "forward"
        X = parse(Int64,ii[2])
        horizontal_position += X
        depth += aim*X
    elseif ii[1] == "up"
        aim -= parse(Int64,ii[2])
    elseif ii[1] == "down"
        aim += parse(Int64,ii[2])
    end
end

println("Part 2:")
println(horizontal_position*depth)
