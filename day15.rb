#!/usr/bin/env ruby

input = File
    .read(ARGV[0])
    .split(',')
    .map(&:to_i)
    .each_with_index
    .map { |n, i| [n, [i + 1, nil]] }
    .to_h
    
[2020, 30000000].each do |part|
    memory = input.dup
    turn = memory.size + 1
    last_number = memory.keys.last

    (part - memory.size).times do |n|
        if memory[last_number] and memory[last_number][1]
            new_number = memory[last_number][0] - memory[last_number][1]
        else
            new_number = 0
        end

        memory[new_number] = [turn, memory[new_number] ? memory[new_number][0] : nil]
        last_number = new_number
        turn += 1
    end

    p last_number
end

