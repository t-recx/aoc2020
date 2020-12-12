#!/usr/bin/env ruby

directions = { 90 => :E, 180 => :S, 270 => :W, 0 => :N }

x, y, angle = 0, 0, 90

File.readlines(ARGV[0]).map(&:strip)
.map { |x| [x[0].to_sym, x[1..-1].to_i] }
.each do |action, value|
    if action == :L
        angle = (angle - value) % 360
    elsif action == :R
        angle = (angle + value) % 360
    elsif action == :F
        action = directions[angle]
    end

    if action == :N
        y -= value;
    elsif action == :S
        y += value;
    elsif action == :E
        x += value;
    elsif action == :W
        x -= value;
    end
end

p x.abs + y.abs