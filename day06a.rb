#!/usr/bin/env ruby

p File.read(ARGV[0]).split("\n\n").map { |group| group.delete("\n").chars.uniq.count }.sum