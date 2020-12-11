#!/usr/bin/env ruby

def direction_occupied?(seats, x, y, inc_x, inc_y)
    loop do
        x += inc_x
        y += inc_y 

        break if x < 0 or y < 0 or not seats[y] or not seats[y][x] or seats[y][x] == 'L'

        return true if seats[y][x] == '#'
    end
end

def occupied_number(seats, x, y)
    [[1,0],[-1,0],[0,-1],[0,1],[-1,-1],[-1,1],[1,-1],[1,1]]
    .select{ |xx, yy| direction_occupied?(seats, x, y, xx, yy) }
    .count
end 

input = File.readlines(ARGV[0]).map(&:strip).map(&:chars)

loop do
    output = input.each_with_index.map { |l, y|
        l.each_with_index.map { |s, x|
            if s== 'L' and occupied_number(input, x, y) == 0
                '#'
            elsif s== '#' and occupied_number(input, x, y) >= 5
                'L'
            else
                s
            end
        }
    }

    break if input == output

    input = output
end

p input.flatten.count('#')
