#!/usr/bin/env ruby

input = File
    .readlines(ARGV[0])
    .map(&:strip)

board = {}
board[0] = {}

input
.each_with_index do |line, y| 
    board[0][y] = {} unless board[0][y]

    line
    .chars
    .each_with_index
    .select { |c, _| c == '#' } 
    .each do |item, x| 
        board[0][y][x] = true
    end
end

def get_neighbours(b, bx, by, bz)
    zs = nil

    if (bz == 0)
        zs = [1, 0, 1] 
    else
        zs = (-1..1) 
    end

    return zs.flat_map { |z|
        (-1..1).flat_map { |y|
            (-1..1).flat_map { |x|
                if (z == 0 && x == 0 && y == 0)
                    false
                elsif (b[z+bz] && b[z+bz][y+by])
                    b[z+bz][y+by][x+bx] 
                end
            }
        }
    }
    .count { |i| i }
end

width = input.first.size
height = input.size
count = 0

(1..6).each do |cycle|
    new_board = {}

    (0..cycle).each do |z|
        new_board[z] = {} unless new_board[z]

        (-cycle..height+cycle).each do |y|
            (-cycle..width+cycle).each do |x|
                new_board[z][y] = {} unless new_board[z][y]

                neighbours = get_neighbours(board, x, y, z)

                if board[z] && board[z][y] && board[z][y][x]
                    if neighbours.between? 2, 3
                        new_board[z][y][x] = true
                        count += z > 0 ? 2 : 1 if cycle == 6
                    end
                else
                    if neighbours == 3
                        new_board[z][y][x] = true
                        count += z > 0 ? 2 : 1 if cycle == 6
                    end
                end
            end
        end
    end

    board = new_board
end

p count
