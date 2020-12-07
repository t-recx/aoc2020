#!/usr/bin/env ruby

def bag_number(input, allowed, times)
    a = input
        .map { |line| line.split(' bags contain') }
        .map { |color, rules| [color, rules.split(',')] }
        .select { |color, rules| color == allowed }
        .flat_map { |color, rules|  
            rules
            .map { |r| r.split(' ', 2) }
            .map { |n, cc| [n, cc.split(' bag')[0]] } 
        } 
        .select { |t, c| t != 'no' }

    if (a.length > 0) 
        return times + a.map { |t, c| times * bag_number(input, c, t.to_i) }.reduce(:+)
    end

    return times
end

input = File.readlines(ARGV[0]).map(&:strip)

p bag_number(input, 'shiny gold', 1) - 1
