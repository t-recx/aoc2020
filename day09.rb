#!/usr/bin/env ruby

def get_invalid_number(lines)
    preamble = lines.slice!(0..24)

    lines.each do |n| 
        indexed_preamble = preamble.each_with_index

        return n if 
            indexed_preamble
            .none? { |x, i| 
                indexed_preamble
                .reject { |_, j| j == i }
                .any? { |y, _| x + y == n }
            }

        preamble.push(n)
        preamble.shift
    end
end

lines = File.readlines(ARGV[0]).map(&:strip).map(&:to_i)

invalid_number = get_invalid_number(lines)

p invalid_number

lines.each_with_index do |n, i|
    a = [n]
    
    lines[i+1..-1].each do |y|
        a.push y

        if a.sum == invalid_number
            return p a.min + a .max
        end
    end
end
