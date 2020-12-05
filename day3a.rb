#!/usr/bin/env ruby

lines = File.readlines(ARGV[0])
.map(&:strip)

w = lines.first.size

p lines
    .each_with_index
    .select { |line, i| line[i * 3 % w] == '#' }
    .count