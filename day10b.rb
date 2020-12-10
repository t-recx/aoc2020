#!/usr/bin/env ruby

def get_possible_arrangement_count(previous, jolts, target)
    count = 0

    jolts.each_with_index do |jolt, i|
        difference = jolt - previous

        if difference >= 1 && difference <= 3
            count += get_possible_arrangement_count(previous, jolts[i+1..-1], target)

            previous = jolt
        end

        if previous == target
            count += 1
            break
        end

        break if difference > 3

        break if previous > target
    end

    return count
end

jolts = File.readlines(ARGV[0]).map(&:strip).map(&:to_i).sort

p get_possible_arrangement_count(0, jolts, jolts.max)