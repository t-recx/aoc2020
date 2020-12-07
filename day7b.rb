#!/usr/bin/env ruby

def bag_number(input, allowed, times)
    times + 
        input
        .map { |line| line.split(' bags contain') }
        .map { |color, rules| [color, rules.split(',')] }
        .select { |color, rules| color == allowed }
        .flat_map { |color, rules|  
            rules
            .map { |r| r.split(' ', 2) }
            .map { |t, rc| [t, rc.split(' bag')[0]] } 
        } 
        .reject { |t, c| t == 'no' }
        .map { |t, c| times * bag_number(input, c, t.to_i) }
        .reduce(0, :+)
end

input = File.readlines(ARGV[0]).map(&:strip)

p bag_number(input, 'shiny gold', 1) - 1
