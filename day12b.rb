#!/usr/bin/env ruby

x, y, wx, wy = 0, 0, 10, -1

File.readlines(ARGV[0]).map(&:strip)
.map { |x| [x[0], x[1..-1].to_i] }
.each do |action, value|
    if action == 'L'
        (value / 90).times { wx, wy = wy, -wx}
    elsif action == 'R'
        (value / 90).times { wx, wy = -wy, wx}
    elsif action == 'N'
        wy -= value;
    elsif action == 'S'
        wy += value;
    elsif action == 'E'
        wx += value;
    elsif action == 'W'
        wx -= value;
    else
        x += wx * value
        y += wy * value
    end
end

p x.abs + y.abs
