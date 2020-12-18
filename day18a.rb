#!/usr/bin/env ruby

def solve_add_mult(expression)
    value = 0

    op = '+'

    expression.split.each do |c|
        if c == '+' or c == '*'
            op = c
        else
            value = [value, c.to_i].reduce(op)
        end
    end

    return value
end

def solve(line)
    loop do
        eop = line.index(')')

        return solve_add_mult(line) unless eop

        expression = line[line[0..eop].rindex('(')..eop]

        line.sub!(expression, solve_add_mult(expression[1..-2]).to_s)
    end
end

p File.readlines(ARGV[0]).map { |line| solve(line) }.sum
