#!/usr/bin/env ruby

def colors(input, allowed, times)
    a = input
        .map { |line| line.split('bags contain') }
        .map { |color, rules| [color, rules.split(',')] }
        .select { |color, rules| color.include? allowed }
        .map { |color, rules| [color, 
            rules
            .map { |r| r.split(' ', 2) }
                .map { |n, cc| [n.sub('no', '0').to_i, cc.split('bag')[0]] } ] } 
        .flat_map { |c, x| x }
        .select { |t, c| t > 0 }

    if (a.length > 0) 
        return times + a.map { |t, c| times * colors(input, c, t) }.reduce(:+)
    end

    return times
end

input = File.readlines(ARGV[0]).map(&:strip)

p colors(input, 'shiny gold', 1) - 1
