#!/usr/bin/env ruby

x, y, wx, wy = 0, 0, 10, -1

File.readlines(ARGV[0]).map(&:strip)
.map { |x| [x[0], x[1..-1].to_i] }
.each do |action, value|
    case action
        when 'L'
            (value / 90).times { wx, wy = wy, -wx}
        when 'R'
            (value / 90).times { wx, wy = -wy, wx}
        when 'N'
            wy -= value;
        when 'S'
            wy += value;
        when 'E'
            wx += value;
        when 'W'
            wx -= value;
        else
            x += wx * value
            y += wy * value
    end
end

p x.abs + y.abs
