#!/usr/bin/env ruby

def get_possible_arrangement_count(previous, jolts, target, visited = [])
    count = 0

    previous_evaluation = visited.select { |x, y, _| x == previous and y == jolts.size }.first

    return previous_evaluation[2] if previous_evaluation

    jolts.each_with_index do |jolt, i|
        difference = jolt - previous

        break if difference > 3

        if difference.between? 1, 3
            if jolt == target
                count += 1
                break
            end

            jolts_rest = jolts[i+1..-1]

            possibilities_number = get_possible_arrangement_count(previous, jolts_rest, target, visited)

            visited.push [previous, jolts_rest.size, possibilities_number]

            count += possibilities_number
            previous = jolt
        end

        break if previous > target
    end

    return count
end

jolts = File.readlines(ARGV[0]).map(&:strip).map(&:to_i).sort

p get_possible_arrangement_count(0, jolts, jolts[-1], [])