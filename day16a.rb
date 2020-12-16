#!/usr/bin/env ruby

input = File
    .read(ARGV[0])

rules = input
    .split('your ticket')[0]
    .split("\n")
    .map { |x| x.split(' ') }
    .map { |x| [x[1], x[3]] }
    .map { |a, b| [a.split('-'), b.split('-')] }
    # .flat_map { |a| a }
    # .map { |a, b| [a.to_i, b.to_i] }

values = input
    .split("nearby tickets:")[1]
    .strip
    .gsub("\n", ",")
    .split(',')
    .map(&:to_i)

error_rate = 0
p values

values.each do |value|
    passed = false

    rules.each do |rule|
        if value.between? rule[0][0].to_i, rule[0][1].to_i or value.between? rule[1][0].to_i, rule[1][1].to_i
            passed = true
        end
    end

    error_rate += value if not passed
end

p error_rate