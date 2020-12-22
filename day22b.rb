#!/usr/bin/env ruby

def game(p1_stack, p2_stack, rounds = {}, is_sub = false)
    player1_win = nil

    loop do 
        round = rounds[p1_stack]

        if round and round[p2_stack]
            player1_win = true
            break
        else
            if not round
                round = {}
                rounds[p1_stack] = round
            end

            round[p2_stack] = true 

            p1_card = p1_stack.shift
            p2_card = p2_stack.shift

            if p1_stack.size >= p1_card and p2_stack.size >= p2_card 
                player1_win = game(p1_stack.take(p1_card), p2_stack.take(p2_card), {}, true)
            else 
                player1_win = p1_card > p2_card
            end

            if player1_win
                p1_stack.push p1_card
                p1_stack.push p2_card
            else
                p2_stack.push p2_card
                p2_stack.push p1_card
            end

            break if p1_stack.empty? or p2_stack.empty?
        end
    end

    return player1_win if is_sub

    return player1_win ? p1_stack : p2_stack
end

p1_stack, p2_stack = File.read(ARGV[0]).split("\n\n").map { |x| x.split("\n")[1..-1].map(&:to_i) }

p game(p1_stack, p2_stack).reverse.each_with_index.map { |x, i| x * (i + 1) }.sum
