#!/usr/bin/env ruby

def solve(expression)
    value = 0

    operator = nil

    expression.split.each do |c|
        if c == '+' or c == '*'
            operator = c
        else
            if operator == '+'
                value = value + c.to_i
            elsif operator == '*'
                value = value * c.to_i
            else
                value = c.to_i
            end
        end
    end

    return value
end

lines = File
    .readlines(ARGV[0])
    .map(&:strip)

sum = 0
lines.each do |line|
    loop do
        eop = line.index(')')

        if (eop)
            sop = line[0..eop].rindex('(')

            expression = line[sop..eop]

            line.sub!(expression, solve(expression[1..-2]).to_s)
        else
            sum += solve(line)
            break
        end
    end
end

p sum