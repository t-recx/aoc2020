#!/usr/bin/env ruby

p File.read(ARGV[0])
.split("\n\n")
.map { |group| [group, group.split] }
.map { |raw, group| 
    raw
    .delete("\n")
    .chars
    .uniq
    .map { |c| group.select { |p| p.include? c }.count }
    .select { |a| a == group.count }
    .count
}
.sum