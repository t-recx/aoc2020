#!/usr/bin/env ruby

def get_black_neighbours(board, x, y)
    bn = 0
    [[-2, 0], [2, 0], [-1, 1], [1, -1], [-1, -1], [1, 1]].each do |ox, oy|
        if board[[x + ox, y + oy]] != nil and board[[x + ox, y + oy]]
            bn += 1
        end
    end
    return bn
end

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

sx = is_black.keys.map { |x, y| x }.min
sy = is_black.keys.map { |x, y| y }.min 
ex = is_black.keys.map { |x, y| x }.max
ey = is_black.keys.map { |x, y| y }.max

output = nil

100.times do |day|
    output = is_black.dup

    sx -= 1
    sy -= 1
    ex += 1
    ey += 1
    (sy..ey).each do |y|
        (sx..ex).each do |x|
            neighbours = get_black_neighbours(is_black, x, y)
            tile_is_black = output[[x,y]] == nil ? false : output[[x,y]]

            if tile_is_black 
                if neighbours == 0 or neighbours > 2
                    output[[x,y]] = false
                end
            else
                if neighbours == 2
                    output[[x,y]] = true
                end
            end
        end
    end

    is_black = output
end

p output.values.count { |x| x }