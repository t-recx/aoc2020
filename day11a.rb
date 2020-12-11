#!/usr/bin/env ruby

def occupied_number(seats, x, y)
    [[x-1,y],[x+1,y],[x,y-1],[x,y+1],[x-1,y-1],[x-1,y+1],[x+1,y-1],[x+1,y+1]]
    .reject { |xx, yy| xx < 0 || yy < 0 }
    .select { |xx, yy| seats[yy] and seats[yy][xx] == '#' }
    .count
end 

input = File.readlines(ARGV[0]).map(&:strip).map { |line| line.chars }

loop do
    output = input.map(&:dup)

    (0..input.size-1).each do |y|
        (0..input.first.size-1).each do |x|
            if input[y][x] != '.'
                occupied_adjacent = occupied_number(input, x, y)

                if input[y][x] == 'L' and occupied_adjacent == 0
                    output[y][x] = '#'
                elsif input[y][x] == '#' and occupied_adjacent >= 4
                    output[y][x] = 'L'
                end
            end
        end
    end

    break if input == output

    input = output
end

p input.flat_map { |x| x }.select { |x| x == '#' }.count