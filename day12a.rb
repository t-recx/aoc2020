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

input = File.readlines(ARGV[0]).map(&:strip).map { |x| [x[0].to_sym, x[1..-1].to_i] }

x, y = 0, 0
directions = { 90 => :E, 180 => :S, 270 => :W, 0 => :N }
angle = 90

input.each do |action, value|
    if action == :L
        angle = (angle - value) % 360
    elsif action == :R
        angle = (angle + value) % 360
    elsif action == :F
        x, y = get_coordinates(directions[angle], value, x, y)    
    else
        x, y = get_coordinates(action, value, x, y)    
    end
end

p x.abs+y.abs