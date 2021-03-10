#!/usr/bin/env ruby

@directions = [[1,0],[-1,0],[0,-1],[0,1],[-1,-1],[-1,1],[1,-1],[1,1]]

def get_occupied_part_a(seats, x, y)
    @directions
    .map { |ix, iy| [x + ix, y + iy] }
    .count { |xx, yy| xx >= 0 && yy >= 0 && seats[yy] && seats[yy][xx] == '#' }
end 

def get_occupied_part_b(seats, x, y)
    @directions.count { |ix, iy| direction_occupied?(seats, x, y, ix, iy) }
end

def direction_occupied?(seats, x, y, ix, iy)
    loop do
        x += ix
        y += iy 

        break if x < 0 or y < 0 or not seats[y] or not seats[y][x] or seats[y][x] == 'L'

        return true if seats[y][x] == '#'
    end
end

def get_occupied(input, evaluation_callback, l_number)
    loop do
        output = input.each_with_index.map { |l, y|
            l.each_with_index.map { |s, x|
                if s == 'L' and evaluation_callback.call(input, x, y) == 0
                    '#'
                elsif s == '#' and evaluation_callback.call(input, x, y) >= l_number
                    'L'
                else
                    s
                end
            }
        }

        break if input == output

        input = output
    end

    input.flatten.count('#')
end

input = File.readlines(ARGV[0]).map(&:strip).map(&:chars)

p get_occupied(input, method(:get_occupied_part_a), 4)
p get_occupied(input, method(:get_occupied_part_b), 5)