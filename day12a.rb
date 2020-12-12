#!/usr/bin/env ruby

directions = { 90 => :E, 180 => :S, 270 => :W, 0 => :N }

x, y, angle = 0, 0, 90

File.readlines(ARGV[0]).map(&:strip)
.map { |x| [x[0].to_sym, x[1..-1].to_i] }
.each do |action, value|
    case action
        when :L
            angle = (angle - value) % 360
        when :R
            angle = (angle + value) % 360
        when :F
            action = directions[angle]
    end

    case action
        when :N
            y -= value;
        when :S
            y += value;
        when :E
            x += value;
        when :W
            x -= value;
    end
end

p x.abs + y.abs