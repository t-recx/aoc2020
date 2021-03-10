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

def run_program(program)
    executed = []
    cur, acc = 0, 0

    loop do
        cur, acc = execute(program[cur], cur, acc)

        break unless program[cur]

        if executed.include? cur
            yield(acc) if block_given?
            return
        end

        executed.push(cur)
    end

    acc
end

original_program = File.readlines(ARGV[0]).map(&:strip)

run_program(original_program) { |acc| p acc } 

previous_instructions = []

original_program.each_with_index do |instruction, i|
    unless instruction.start_with? 'acc'
        new_instruction = instruction.start_with?('nop') ? 'jmp ' : 'nop ' + instruction.split[1]

        acc = run_program(previous_instructions + [new_instruction] + original_program[i+1..-1])

        return p acc if acc
    end

    previous_instructions.push(instruction)
end
