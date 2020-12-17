#!/usr/bin/env ruby

input = File
    .readlines(ARGV[0])
    .map(&:strip)

board = {}
board[0] = {}
board[0][0] = {}

input
.each_with_index do |line, y| 
    board[0][0][y] = {} unless board[0][0][y]

    line
    .chars
    .each_with_index
    .select { |c, _| c == '#' } 
    .each do |item, x| 
        board[0][0][y][x] = true
    end
end

def get_neighbours(b, bx, by, bz, bw)
    zs = nil

    if (bz == 0)
        zs = [1, 0, 1] 
    else
        zs = (-1..1) 
    end

    ws = nil

    if (bw == 0)
        ws = [1, 0, 1] 
    else
        ws = (-1..1) 
    end

    count = 0

    ws.each { |w|
        zs.each { |z|
            (-1..1).each { |y|
                (-1..1).each { |x|
                    unless (z == 0 && x == 0 && y == 0 && w == 0)
                        if (b[w+bw] && b[w+bw][z+bz] && b[w+bw][z+bz][y+by] && b[w+bw][z+bz][y+by][x+bx])
                            count += 1

                            return count if count > 3
                        end
                    end
                }
            }
        }
    }

    return count
end

width = input.first.size
height = input.size
count = 0

(1..6).each do |cycle|
    new_board = {} if cycle < 6

    (-cycle..cycle).each do |w|
        new_board[w] = {} if cycle < 6 && !new_board[w]
        (0..cycle).each do |z|
            new_board[w][z] = {} if cycle < 6 && !new_board[w][z]

            (-cycle..height+cycle).each do |y|
                (-cycle..width+cycle).each do |x|
                    new_board[w][z][y] = {} if cycle < 6 && !new_board[w][z][y]

                    neighbours = get_neighbours(board, x, y, z, w)

                    if board[w] && board[w][z] && board[w][z][y] && board[w][z][y][x]
                        if neighbours.between? 2, 3
                            new_board[w][z][y][x] = true if cycle < 6
                            count += z > 0 ? 2 : 1 if cycle == 6
                        end
                    else
                        if neighbours == 3
                            new_board[w][z][y][x] = true if cycle < 6
                            count += z > 0 ? 2 : 1 if cycle == 6
                        end
                    end
                end
            end
        end
    end

    board = new_board
end

p count

