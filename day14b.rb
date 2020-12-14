#!/usr/bin/env ruby

lines = File
    .readlines(ARGV[0])
    .map(&:strip)
    .map { |line| line.split(' = ') }

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

        new_mem_address = mask.chars.each_with_index.map { |c, i| c == '0' ? mem_address[i] : c == '1' ? '1' : c }.join('')

        if new_mem_address.include? 'X'         
            n.times do |i|
                mem_address_iteration = new_mem_address
                ii = 0
                bits = i.to_s(2).rjust(x_count, '0').reverse

                mem_address_iteration = mem_address_iteration.reverse
                mem_address_iteration.chars.each_with_index.select { |c, _| c == 'X'}.each do |_, i|
                    mem_address_iteration[i] = bits[ii]     
                    ii += 1 
                end
                mem_address_iteration = mem_address_iteration.reverse

                mem[mem_address_iteration] = value.to_i
            end
        else
            mem[new_mem_address] = value.to_i
        end
    end
end

p mem.map { |k, v| v }.sum
