# 

struct Endpoint
    x::Int64
    y::Int64
end

function Endpoint(v::Vector{Int64})
    return Endpoint(v[1],v[2])
end

struct Line
    v::Vector{Endpoint}
end

function isvertical(p1::Endpoint, p2::Endpoint)
    p1.x == p2.x 
end

function isvertical(l::Line)
    l.v[1].x == l.v[2].x
end

function ishorizontal(p1::Endpoint, p2::Endpoint)
    p1.y == p2.y 
end

function ishorizontal(l::Line)
    l.v[1].y == l.v[2].y
end

function parse_inputs(fn::String)
    inputs = readlines(fn)
    re = r"([0-9]+),([0-9]+) -> ([0-9]+),([0-9]+)"
    m = match.(re,inputs)

    lines = Vector{Line}(undef,length(m))
    for i in 1:length(m)
        points = parse.(Int64,m[i])
        lines[i] = Line([Endpoint(points[1:2]),Endpoint(points[3:4])])
    end

    return lines
end

function draw!(m::Matrix{Int64},l::Line)
    if ishorizontal(l)
        y = l.v[1].y # same for both endpoints
        lb,ub = extrema([l.v[1].x,l.v[2].x])

        i = lb
        while i <= ub
            m[i+1,y+1] = m[i+1,y+1]+1
            i = i+1
        end
    elseif isvertical(l)
        x = l.v[1].x # same for both endpoints
        lb,ub = extrema([l.v[1].y,l.v[2].y])

        i = lb
        while i <= ub
            m[x+1,i+1] = m[x+1,i+1]+1
            i = i+1
        end
    else
        xlb,xlbi = findmin([l.v[1].x,l.v[2].x])
        ylb,ylbi = findmin([l.v[1].y,l.v[2].y])
        xub,xubi = findmax([l.v[1].x,l.v[2].x])
        yub,yubi = findmax([l.v[1].y,l.v[2].y])

        left_point = l.v[xlbi]
        right_point = l.v[xubi]

        if left_point.y < right_point.y
            slope = 1
        else
            slope = -1
        end

        ix, iy = xlb,left_point.y

        while ix <= xub 
            m[ix+1, iy+1] = m[ix+1, iy+1] + 1
            ix = ix+1
            iy = iy+slope
        end
    end

    return m
end

#inputs = parse_inputs("test-input.txt")
inputs = parse_inputs("input.txt")

m = zeros(Int64,1000,1000)

hv_lines = inputs[findall(ishorizontal.(inputs) .|| isvertical.(inputs))]

res = [draw!(m,hvi) for hvi in hv_lines]

println("part 1:")
println(length(findall(m.>1)))

m2 = zeros(Int64,1000,1000)

res2 = [draw!(m2,li) for li in inputs]

println("part 2:")
println(length(findall(m2.>1)))
