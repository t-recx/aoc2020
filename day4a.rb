#!/usr/bin/env ruby

puts File
    .read(ARGV[0])
    .split("\n\n")
    .select { |line| ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid'].all? { |key| line.include? key } }
    .count()