#!/usr/bin/env ruby

def execute(instruction, cur, acc)
    op, arg = instruction.split

    if op == 'jmp'
        cur += arg.to_i
    else
        cur += 1
    end

    acc += arg.to_i if op == 'acc'

    [cur, acc]
end

executed = []
cur, acc = 0, 0

program = File.readlines(ARGV[0]).map(&:strip)

loop do
    cur, acc = execute(program[cur], cur, acc)

    return p acc if executed.include? cur

    executed.push(cur)
end