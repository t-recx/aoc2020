#!/usr/bin/env ruby

def part_a(lines)
    mask = nil

    mem = {}

    lines.each do |token, value|
        if (token == 'mask')
            mask = value
        else
            bits = value.to_i.to_s(2).rjust(36, '0')

            mem[token[4..-2]] = mask.chars.each_with_index.map { |c, i| c == 'X' ? bits[i] : c }.join.to_i(2)
        end
    end

    mem.sum { |_, v| v }
end

def part_b(lines)
    mask = nil
    x_count = nil
    n = nil

    mem = {}

    lines.each do |token, value|
        if (token == 'mask')
            mask = value
            x_count = mask.count('X')
            n = 2**x_count
        else
            mem_address = token[4..-2].to_i.to_s(2).rjust(36, '0')

            new_mem_address = mask.chars.each_with_index.map { |c, i| c == '0' ? mem_address[i] : c }

            if new_mem_address.any? 'X'         
                n.times do |i|
                    mem_address_iteration = new_mem_address.dup
                    bits = i.to_s(2).rjust(x_count, '0')

                    mem_address_iteration.each_with_index.select { |c, _| c == 'X'}.each_with_index do |x, ii|
                        mem_address_iteration[x[1]] = bits[ii] 
                    end

                    mem[mem_address_iteration.join] = value.to_i
                end
            else
                mem[new_mem_address.join] = value.to_i
            end
        end
    end

    mem.sum { |_, v| v }
end

lines = File.readlines(ARGV[0]).map(&:strip).map { |line| line.split(' = ') }

p part_a(lines)
p part_b(lines)
