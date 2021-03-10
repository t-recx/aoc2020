#!/usr/bin/env ruby

lines = File.readlines(ARGV[0]).map(&:strip)

w = lines.first.size

p lines
    .each_with_index
    .count { |line, i| line[i * 3 % w] == '#' }

p [[1,1],[3,1],[5,1],[7,1],[1,2]]
    .map { |right, down|
        lines
            .each_with_index
            .count { |line, i| i % down == 0 && line[(i / down) * right % w] == '#' }
    }
    .reduce(:*)