#!/usr/bin/env ruby

def solve_op(expression, op)
    loop do
        opi = expression.index(op)

        if opi
            first = expression[0..opi-1].split[-1].to_i

            second = expression[opi+1..-1].split(' ', 2)[0].to_i

            value = first + second if op == '+'
            value = first * second if op == '*'
        
            expression.sub!("#{first} #{op} #{second}", value.to_s)
        else
            return expression
        end
    end
end

def solve_add_mult(expression)
    solve_op(solve_op(expression, '+'), '*')
end

def solve(line)
    loop do
        eop = line.index(')')

        if (eop)
            expression = line[line[0..eop].rindex('(')..eop]

            line.sub!(expression, solve_add_mult(expression[1..-2]))
        else
            return solve_add_mult(line).to_i
        end
    end
end

p File
    .readlines(ARGV[0])
    .map(&:strip)
    .map { |line| solve(line) }
    .reduce(:+)
