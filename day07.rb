#!/usr/bin/env ruby

def bag_colors(input, selected)
    a = input
        .map { |line| line.split(' bags contain') }
        .select { |_, rules| rules.include? selected }
        .map { |color, _| color }

    if a.size > 0
        return a.concat(a.flat_map { |c| bag_colors(input, c) })
    end

    a
end

def bag_number(input, selected, times)
    times + 
        input
        .select { |color, _| color == selected }
        .flat_map { |_, rules|  
            rules
            .map { |r| r.split(' ', 2) }
            .map { |t, rc| [t, rc.split(' bag')[0]] } 
        } 
        .reject { |t, _| t == 'no' }
        .sum { |t, c| times * bag_number(input, c, t.to_i) }
end

input = File.readlines(ARGV[0]).map(&:strip)

input_b = input
        .map { |line| line.split(' bags contain') }
        .map { |color, rules| [color, rules.split(',')] }

p bag_colors(input, 'shiny gold').uniq.size

p bag_number(input_b, 'shiny gold', 1) - 1