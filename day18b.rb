#!/usr/bin/env ruby

def solve_op(expression, op)
    loop do
        opi = expression.index(op)

        return expression unless opi

        first = expression[0..opi-1].split[-1]
        second = expression[opi+1..-1].split(' ', 2)[0]

        expression.sub!("#{first} #{op} #{second}", [first, second].map(&:to_i).reduce(op).to_s)
    end
end

def solve(line)
    loop do
        eop = line.index(')')

        return solve_op(solve_op(line, '+'), '*').to_i unless eop

        expression = line[line[0..eop].rindex('(')..eop]

        line.sub!(expression, solve_op(solve_op(expression[1..-2], '+'), '*'))
    end
end

p File.readlines(ARGV[0]).map { |line| solve(line) }.sum
