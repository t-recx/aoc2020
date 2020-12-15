#!/usr/bin/env ruby

memory = File
    .read(ARGV[0])
    .split(',')
    .map(&:to_i)

last_number = nil

(2020 - memory.size).times do |n|
    last_number = memory.last
    memory_number = memory.each_with_index.select { |mn, i| mn == last_number }

    if memory_number.size <= 1
        memory.push 0
    else
        memory.push memory_number[-1][1] - memory_number[-2][1]
    end
end

p memory.last