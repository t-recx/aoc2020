#!/usr/bin/env ruby

def game(p1_stack, p2_stack, rounds = {})
    winner = nil

    loop do 
        p1_stack_id = p1_stack.to_s
        p2_stack_id = p2_stack.to_s

        if rounds[p1_stack.size] and rounds[p1_stack.size][p2_stack.size] and rounds[p1_stack.size][p2_stack.size][p1_stack_id] and rounds[p1_stack.size][p2_stack.size][p1_stack_id][p2_stack_id]
            winner = 1
            break
        else
            rounds[p1_stack.size] = {} unless rounds[p1_stack.size]
            rounds[p1_stack.size][p2_stack.size] = {} unless rounds[p1_stack.size][p2_stack.size]
            rounds[p1_stack.size][p2_stack.size][p1_stack_id] = {} unless rounds[p1_stack.size][p2_stack.size][p1_stack_id]
            rounds[p1_stack.size][p2_stack.size][p1_stack_id][p2_stack_id] = true 

            p1_card = p1_stack.shift
            p2_card = p2_stack.shift

            if p1_stack.size >= p1_card and p2_stack.size >= p2_card 
                winner, _ = game(p1_stack.take(p1_card), p2_stack.take(p2_card), [])
            else
                if p1_card > p2_card
                    winner = 1
                else
                    winner = 2
                end
            end

            if winner == 1
                p1_stack.push p1_card
                p1_stack.push p2_card
            elsif winner == 2
                p2_stack.push p2_card
                p2_stack.push p1_card
            end

            break if p1_stack.size == 0 or p2_stack.size == 0
        end
    end

    return [winner, winner == 1 ? p1_stack : p2_stack]
end

p1_stack, p2_stack = File.read(ARGV[0]).split("\n\n").map { |x| x.split("\n")[1..-1].map(&:to_i) }

_, stack = game(p1_stack, p2_stack)

p stack.reverse.each_with_index.map { |x, i| x * (i + 1) }.sum
