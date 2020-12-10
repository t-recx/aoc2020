#!/usr/bin/env ruby

one, three = 0, 1
previous = 0

jolts = File.readlines(ARGV[0]).map(&:strip).map(&:to_i)

jolts.sort.each do |jolt|
    difference = jolt - previous 

    one += 1 if difference == 1
    three += 1 if difference == 3
    previous = jolt if [1, 3].include? difference
end

p one * three