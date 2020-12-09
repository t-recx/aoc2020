#!/usr/bin/env ruby

def get_invalid_number(lines)
    preamble = lines.slice!(0..24)

    lines.each do |n| 
        return n if 
            preamble
            .each_with_index
            .none? { |x, i| 
                preamble
                .each_with_index
                .reject { |_, j| j == i }
                .any? { |y, j| x + y == n }
            }

        preamble.push(n)
        preamble.shift
    end
end

lines = File.readlines(ARGV[0]).map(&:strip).map(&:to_i)

p invalid_number = get_invalid_number(lines)

lines.each_with_index do |n, i|
    a = [n]
    
    lines[i+1..-1].each do |y|
        a.push y

        if a.sum == invalid_number
            return p a.min + a .max
        end
    end
end
