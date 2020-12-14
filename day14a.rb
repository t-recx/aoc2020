#!/usr/bin/env ruby

lines = File
    .readlines(ARGV[0])
    .map(&:strip)
    .map { |line| line.split(' = ') }

mask = nil

mem = {}

lines.each do |token, value|
    if (token == 'mask')
        mask = value
    else
        bits = value.to_i.to_s(2).rjust(36, '0')

        mem[token[4..-2]] = mask.chars.each_with_index.map { |c, i| c == '1' ? bits[i] : c }.join('').to_i(2)
    end
end

p mem.map { |k, v| v }.sum