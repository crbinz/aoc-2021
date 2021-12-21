mutable struct BingoSquare
    value::Int64
    marked::Bool
end

mutable struct BingoBoard
    board::Matrix{BingoSquare}
end

function BingoSquare(val::Int64)
    BingoSquare(val,false)
end

function mark!(board::BingoBoard, val)
    idx = findfirst(getfield.(board.board, Ref(:value)) .== val)
    if !isnothing(idx)
        board.board[idx].marked = true
    end
end

function check(board::BingoBoard)
    marks = reshape(getfield.(board.board, Ref(:marked)), BOARD_SIZE, BOARD_SIZE)
    if !isnothing(findfirst(sum(marks,dims=1) .== BOARD_SIZE)) ||
        !isnothing(findfirst(sum(marks,dims=2) .== BOARD_SIZE))
        return true
    else
        return false
    end
end

function score(board::BingoBoard, call)
    marks = reshape(getfield.(board.board, Ref(:marked)), BOARD_SIZE, BOARD_SIZE)
    values = reshape(getfield.(board.board, Ref(:value)), BOARD_SIZE, BOARD_SIZE)

    valsum = sum(.!(marks).*values)
    return valsum*call
end

const BOARD_SIZE = 5

#input_lines = readlines("test_input.txt")
input_lines = readlines("input.txt")

calls = parse.(Int64,split(input_lines[1],','))

num_boards = Int(length(input_lines[2:end])/(BOARD_SIZE+1))

boards = Vector{BingoBoard}(undef, num_boards)

for i in 1:num_boards
    local start_idx
    start_idx = 3*(2*i-1)
    squares = [BingoSquare.(parse.(Int64, split(input_lines[j], ' ', keepempty=false)))
               for j in start_idx:(start_idx+BOARD_SIZE-1)]
    boards[i] = BingoBoard(permutedims(hcat(squares...)))
end
    
# Part 1
@show "Part 1"
for call in calls
    mark!.(boards, Ref(call))
    checks = check.(boards)
    winner = findfirst(checks)
    if !isnothing(winner)
        @show winner
        @show call
        @show score(boards[winner],call)
        break
    end
end

# Part 2
@show "Part 2"
function part2()
    flag = false
    loser = nothing
    for call in calls
        if flag
            mark!(boards[loser],call)
            if check(boards[loser])
                @show loser
                @show call
                @show score(boards[loser],call)
                break
            end
        end
        mark!.(boards, Ref(call))
        checks = check.(boards)

        if sum(checks) == num_boards-1
            loser = findfirst(.!(checks))
            flag = true
        end
    end
end

part2()
