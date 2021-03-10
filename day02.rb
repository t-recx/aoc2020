#!/usr/bin/env ruby

lines = File.readlines(ARGV[0])

p lines
.map { |line| line.split(/[\s-]/) }
.count { |min, max, letter, password| password.count(letter).between?(min.to_i, max.to_i)  }

p lines
.map { |line| line.split(/[\s:-]/) }
.map { |f, s, l, _, p| [f.to_i - 1, s.to_i - 1, l, p] }
.count { |f, s, l, p| (p[f] == l && p[s] != l) || (p[f] != l && p[s] == l) }