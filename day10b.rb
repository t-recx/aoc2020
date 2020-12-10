#!/usr/bin/env ruby

# def get_possible_arrangement(previous, jolts, target)
#     possible = []

#     jolts.sort.each do |jolt|
#         difference = jolt - previous 

#         if [1, 3].include? difference
#             previous = jolt
#             possible.push(jolt)
#         end

#         if previous + 3 == target
#             return possible
#         end

#         break if difference > 3

#         break if previous + 3 > target
#     end

#     return nil
# end

def get_possible_arrangement_count(previous, jolts, target)
    arrangements = []
    count = 0

    jolts.each_with_index do |jolt, i|
        difference = jolt - (previous.last || 0)

        if (1..3).include? difference
            arrangements.concat get_possible_arrangement_count(previous, jolts[i+1..-1], target)
        end

        if (1..3).include? difference
            previous.push jolt

        end

        if (previous.last || 0) == target
            arrangements.push previous
            break
        end

        break if difference > 3

        break if (previous.last || 0) > target
    end

    return arrangements
end

jolts = File.readlines(ARGV[0]).map(&:strip).map(&:to_i).sort

jolts_builtin = jolts.max

p get_possible_arrangement_count([], jolts, jolts_builtin).count