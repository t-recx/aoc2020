#!/usr/bin/env ruby

def colors(input, allowed)
    a = input
        .map { |line| line.split(' bags contain') }
        .select { |color, rules| rules.include? allowed }
        .map { |color, rules| color }

    if a.length > 0
        return a.concat(a.flat_map { |c| colors(input, c) })
    end

    return a
end

input = File.readlines('day7.input').map(&:strip)

p colors(input, 'shiny gold').uniq.count