#!/usr/bin/env ruby

def direction_occupied?(seats, x, y, inc_x, inc_y)
    xx, yy = x, y
    width = seats.first.size

    loop do
        xx += inc_x
        yy += inc_y 

        break if xx < 0 or yy < 0 or xx >= width or not seats[yy] or seats[yy][xx] == 'L'

        return true if seats[yy][xx] == '#'
    end
end

def occupied_number(seats, x, y)
    [[1,0],[-1,0],[0,-1],[0,1],[-1,-1],[-1,1],[1,-1],[1,1]]
    .select{ |xx, yy| direction_occupied?(seats, x, y, xx, yy) }
    .count
end 

input = File.readlines(ARGV[0]).map(&:strip).map { |line| line.chars }

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

p input.flat_map { |x| x }.select { |x| x == '#' }.count
