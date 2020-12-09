#!/usr/bin/env ruby

def bag_number(input, allowed, times)
    times + 
        input
        .select { |color, rules| color == allowed }
        .flat_map { |color, rules|  
            rules
            .map { |r| r.split(' ', 2) }
            .map { |t, rc| [t, rc.split(' bag')[0]] } 
        } 
        .reject { |t, c| t == 'no' }
        .map { |t, c| times * bag_number(input, c, t.to_i) }
        .sum
end

input = File.readlines(ARGV[0]).map(&:strip)
        .map { |line| line.split(' bags contain') }
        .map { |color, rules| [color, rules.split(',')] }

p bag_number(input, 'shiny gold', 1) - 1
