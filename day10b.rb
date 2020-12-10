#!/usr/bin/env ruby

def get_possible_arrangement_count(previous, jolts, target, visited = [])
    count = 0

    previous_evaluation = visited.select { |x, y, _| x == previous and y == jolts }.first

    if previous_evaluation
        return previous_evaluation[2]
    end

    jolts.each_with_index do |jolt, i|
        difference = jolt - previous

        if difference.between? 1, 3
            jolts_rest = jolts[i+1..-1]
            possibilities_number = 0

            possibilities_number = get_possible_arrangement_count(previous, jolts_rest, target, visited)

            visited.push([previous, jolts_rest, possibilities_number])  

            count += possibilities_number
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

p get_possible_arrangement_count(0, jolts, jolts.max, [])