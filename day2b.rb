#!/usr/bin/env ruby

p File.readlines(ARGV[0])
.map { |line| line.split(/[\s:-]/) }
.map { |f, s, l, _, p| [f.to_i - 1, s.to_i - 1, l, p] }
.select { |f, s, l, p| (p[f] == l && p[s] != l) || (p[f] != l && p[s] == l) }
.count
