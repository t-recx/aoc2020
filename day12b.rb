#!/usr/bin/env ruby

def get_coordinates(action, value, x, y)
    if action == :N
        y -= value;
    elsif action == :S
        y += value;
    elsif action == :E
        x += value;
    elsif action == :W
        x -= value;
    end

    [x,y]
end

def apply_angle(action, value, wx, wy)
    rotations = (value / 90) % 4

    rotations.times do 
        if action == :R
            wx, wy = -wy, wx
        elsif action == :L
            wx, wy = wy, -wx
        end
    end

    [wx, wy]
end

input = File.readlines(ARGV[0]).map(&:strip).map { |x| [x[0].to_sym, x[1..-1].to_i] }

x, y = 0, 0
wx, wy = 10, -1

input.each do |action, value|
    if action == :L
        wx, wy = apply_angle(action, value, wx, wy)
    elsif action == :R
        wx, wy = apply_angle(action, value, wx, wy)
    elsif action == :F
        x += wx * value
        y += wy * value
    else
        wx, wy = get_coordinates(action, value, wx, wy)    
    end
end

p x.abs+y.abs
