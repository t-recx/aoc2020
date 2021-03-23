#!/usr/bin/env ruby

lines = File.readlines(ARGV[0]).map(&:strip)

indexed_lines = lines.each_with_index

w = lines.first.size

p indexed_lines.count { |line, i| line[i * 3 % w] == '#' }

p [[1,1],[3,1],[5,1],[7,1],[1,2]]
    .map { |right, down|
        indexed_lines
            .count { |line, i| i % down == 0 && line[(i / down) * right % w] == '#' }
    }
    .reduce(:*)