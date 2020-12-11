#!/usr/bin/env ruby

def occupied_number(seats, x, y)
    [[x-1,y],[x+1,y],[x,y-1],[x,y+1],[x-1,y-1],[x-1,y+1],[x+1,y-1],[x+1,y+1]]
    .reject { |xx, yy| xx < 0 || yy < 0 || !seats[yy] }
    .select { |xx, yy| seats[yy][xx] == '#' }
    .count
end 

input = File.readlines(ARGV[0]).map(&:strip).map { |line| line.chars }

loop do
    output = input.each_with_index.map { |l, y|
        l.each_with_index.map { |s, x|
            if s== 'L' and occupied_number(input, x, y) == 0
                '#'
            elsif s== '#' and occupied_number(input, x, y) >= 4
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