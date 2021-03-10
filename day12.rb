#!/usr/bin/env ruby

def part_a(input)
    directions = { 90 => :E, 180 => :S, 270 => :W, 0 => :N }

    x, y, angle = 0, 0, 90

    input.each do |action, value|
        angle = (angle - value) % 360 if action == :L
        angle = (angle + value) % 360 if action == :R
        action = directions[angle] if action == :F

        y -= value if action == :N
        y += value if action == :S
        x += value if action == :E
        x -= value if action == :W
    end

    x.abs + y.abs
end

def part_b(input)
    x, y, wx, wy = 0, 0, 10, -1

    input.each do |action, value|
        case action
            when :L
                (value / 90).times { wx, wy = wy, -wx}
            when :R
                (value / 90).times { wx, wy = -wy, wx}
            when :N
                wy -= value
            when :S
                wy += value
            when :E
                wx += value
            when :W
                wx -= value
            else
                x += wx * value
                y += wy * value
        end
    end

    x.abs + y.abs
end

input = File.readlines(ARGV[0]).map(&:strip).map { |x| [x[0].to_sym, x[1..-1].to_i] }

p part_a(input)
p part_b(input)