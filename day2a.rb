#!/usr/bin/env ruby

p File.readlines(ARGV[0])
.map { |line| line.split(/[\s-]/) }
.select { |min, max, letter, password| password.count(letter).between?(min.to_i, max.to_i)  }
.count