#!/usr/bin/env ruby

def execute(instruction, cur, acc)
    tokens = instruction.split

    if tokens[0] == 'jmp'
        cur += tokens[1].to_i()
    else
        cur += 1
    end

    acc += tokens[1].to_i if tokens[0] == 'acc'

    [cur, acc]
end

def try_program(program)
    executed = []
    cur, acc = 0, 0

    loop do
        cur, acc = execute(program[cur], cur, acc)

        break unless program[cur]

        return nil if (executed.include? cur)

        executed.push(cur)
    end

    return acc
end

original_program = File.readlines(ARGV[0]).map(&:strip)

previous_instructions = []

original_program.each_with_index do |line, i|
    unless line.start_with? 'acc'
        new_line = line.start_with?('nop') ? 'jmp ' : 'nop ' + line.split[1]

        acc = try_program(previous_instructions + [new_line] + original_program[i+1..-1])

        return p acc if acc
    end

    previous_instructions.push(line)
end
