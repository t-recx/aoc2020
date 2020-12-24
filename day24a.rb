#!/usr/bin/env ruby

input = File.readlines(ARGV[0]).map(&:strip)

is_black = {}

input.each do |instructions|
    i = 0
    x, y = 0, 0

    loop do
        ox, oy = 0, 0

        case instructions[i]
        when 'e'
            ox += 2
        when 'w'
            ox -= 2
        when 's'
            i += 1
            oy += 1
            if instructions[i] == 'e'
                ox += 1
            else
                ox -= 1
            end
        when 'n'
            i += 1
            oy -= 1
            if instructions[i] == 'e'
                ox += 1
            else
                ox -= 1
            end
        end
            
        x += ox
        y += oy
        i += 1
        break unless instructions[i]
    end

    is_black[[x,y]] = is_black[[x,y]] == nil ? true : !is_black[[x, y]] 
end

p is_black.values.count { |x| x }