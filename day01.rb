#!/usr/bin/env ruby

lines = File.readlines(ARGV[0]).map(&:to_i)

lines[0..-2].each_with_index do |x, xi| 
    v = lines[xi+1..-1].select { |y| x + y == 2020 }.first

    if v
        p x * v 
        break
    end
end

lines[0..-2].each_with_index do |x, xi| 
    lines[xi+1..-2].each_with_index do |y, yi|
        v = lines[yi+1..-1].select { |z| x + y + z == 2020 }.first

        return p x * y * v if v
    end
end