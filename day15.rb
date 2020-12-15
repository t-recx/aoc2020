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
        last_kvp = memory[last_number]

        if last_kvp and last_kvp[1]
            new_number = last_kvp[0] - last_kvp[1]
        else
            new_number = 0
        end

        new_kvp = memory[new_number]

        memory[new_number] = [turn, new_kvp ? new_kvp[0] : nil]

        last_number = new_number
        turn += 1
    end

    p last_number
end

