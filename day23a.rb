#!/usr/bin/env ruby

input = File.read(ARGV[0]).strip.chars.map(&:to_i)
output = nil

100.times do |move|
    current_cup = input.shift
    pick_up = input.shift(3)
    
    if input.any? { |c| c < current_cup }
        destination_index = input.index(input.select { |c| c < current_cup }.max)
    else
        destination_index = input.index(input.max)
    end

    input.insert(destination_index+1, *pick_up)
    input.push current_cup
end

input += input

puts input[input.index(1)+1..input.rindex(1)-1].join
