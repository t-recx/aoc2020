#!/usr/bin/env ruby

def bsp(l, u, c)
    v = (u - l) / 2

    if c == 'F' or c == 'L'
        u = l + v
    else
        l += v
    end

    [l, u]
end

ids = File.readlines(ARGV[0])
    .map(&:strip)
    .map { |line| 
        d, u = 0, 128
        l, r = 0, 8
        a = line.chars

        a.shift(7).each { |c| d, u = bsp(d, u, c) }

        a.each { |c| l, r = bsp(l, r, c) }
        
        d * 8 + l
    }

p ids.max

ids
.sort
.each_cons(2) do |crt, nxt| 
    candidate = nxt - 1

    if crt != candidate
        p candidate
        break
    end
end