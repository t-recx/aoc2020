#!/usr/bin/env ruby

p1_stack, p2_stack = File.read(ARGV[0]).split("\n\n").map { |x| x.split("\n")[1..-1].map(&:to_i) }

loop do 
    p1_card = p1_stack.shift
    p2_card = p2_stack.shift

    if p1_card > p2_card
        p1_stack.push p1_card
        p1_stack.push p2_card
    elsif p2_card > p1_card
        p2_stack.push p2_card
        p2_stack.push p1_card
    end

    break if p1_stack.size == 0 or p2_stack.size == 0
end

p (p1_stack.size == 0 ? p2_stack : p1_stack).reverse.each_with_index.map { |x, i| x * (i + 1) }.sum
