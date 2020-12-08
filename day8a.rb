#!/usr/bin/env ruby

def execute(instruction, cur, acc)
    tokens = instruction.split

    if tokens[0] == 'acc'
        acc += tokens[1].to_i
    elsif tokens[0] == 'jmp'
        cur += tokens[1].to_i
    end

    [cur, acc]
end

executed = []
cur, acc = 0, 0

program = File.readlines(ARGV[0]).map(&:strip)

loop do
    new_cur, acc = execute(program[cur], cur, acc)

    cur = new_cur == cur ? cur + 1 : new_cur

    return p acc if (executed.include? cur)

    executed.push(cur)
end