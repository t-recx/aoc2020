#!/usr/bin/env ruby

lines = File
    .readlines(ARGV[0])
    .map(&:to_i)

lines[0..-2]
.each_with_index do |x, xi| 
    v = lines[xi+1..-1].select { |y| x + y == 2020 }.first

    return p x * v if v
end