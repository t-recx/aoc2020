#!/usr/bin/env ruby

p File.read(ARGV[0]).split("\n\n").map { |group| group("\n").chars.count }.sum