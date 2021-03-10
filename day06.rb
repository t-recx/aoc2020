#!/usr/bin/env ruby

input = File.read(ARGV[0]).split("\n\n").map { |group| [group.delete("\n").chars.uniq, group.split] }

p input.sum { |uc, _| uc.size }

p input.sum { |uc, group| uc.count { |c| group.count { |p| p.include? c } == group.size } }