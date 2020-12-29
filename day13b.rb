#!/usr/bin/env ruby

def get_mod_inverse(n, m)
    n = n % m

    (1..m).each do |x|
        if ((n * x) % m == 1)
            return x
        end
    end

    return 1
end

offset = 0
ids = {}

File.readlines(ARGV[0]).map(&:strip)[1].split(',').map { |id| id }
.each do |token|
    if token != 'x' 
        ids[token.to_i] = offset > 0 ? token.to_i - offset : 0
    end

    offset += 1
end

n_all = ids.keys.reduce(:*)

sum = ids.map { |id, offset| [id, offset, n_all/id] }.map { |id, offset, ni| offset * ni * get_mod_inverse(ni, id) }.sum

loop do 
    break if sum - n_all < 0

    sum -= n_all
end

p sum
