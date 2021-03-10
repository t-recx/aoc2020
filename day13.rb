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

def part_a(lines)
    departing_ts = lines[0].to_i

    lines[1]
    .split(',')
    .reject { |id| id == 'x' }
    .map { |id| id.to_i }
    .map { |id| [id, id * (departing_ts / id + 1) - departing_ts] }
    .sort_by { |_, waiting_time| waiting_time }[0]
    .reduce(:*)
end

def part_b(lines)
    offset = 0
    ids = {}

    lines[1].split(',')
    .each do |token|
        if token != 'x' 
            ids[token.to_i] = offset > 0 ? token.to_i - offset : 0
        end

        offset += 1
    end

    n_all = ids.keys.reduce(:*)

    sum = ids.map { |id, offset| [id, offset, n_all/id] }.sum { |id, offset, ni| offset * ni * get_mod_inverse(ni, id) }

    loop do 
        break if sum - n_all < 0

        sum -= n_all
    end

    sum
end

lines = File.readlines(ARGV[0]).map(&:strip)

p part_a(lines)
p part_b(lines)