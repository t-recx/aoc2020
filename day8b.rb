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

def try_program(program)
    executed = []
    cur, acc = 0, 0

    loop do
        new_cur, acc = execute(program[cur], cur, acc)

        cur = new_cur == cur ? cur + 1 : new_cur

        break unless program[cur]

        return nil if (executed.include? cur)

        executed.push(cur)
    end

    return acc
end

original_program = File.readlines(ARGV[0]).map(&:strip)

previous_instructions = []

original_program.each_with_index do |line, i|
    tokens = line.split

    if tokens[0] != 'acc'
        if tokens[0] == 'nop'
            new_line = line.sub('nop', 'jmp')
        else
            new_line = line.sub('jmp', 'nop')
        end

        acc = try_program(previous_instructions + [new_line] + original_program[i+1..-1])

        return p acc if acc
    end

    previous_instructions.push(line)
end
