#!/usr/bin/env ruby

class Node
    attr_accessor :value
    attr_accessor :nxt

    def initialize(value)
        @nxt = self
        @value = value
    end

    def link(node)
        nxt_node = @nxt

        i_node = node
        loop do
            break unless i_node.nxt 
            break if i_node.nxt == i_node
            break if i_node.nxt == node
            i_node = i_node.nxt
        end

        i_node.nxt = nxt_node
        @nxt = node
    end

    def unlink(n)
        nxt_node = @nxt

        i_node = nxt_node
        (n-1).times do
           i_node = i_node.nxt 
        end

        @nxt = i_node.nxt
        i_node.nxt = nil

        return nxt_node
    end
end

def contains_value(node, n, value)
    n.times do 
        return true if node.value == value
        node = node.nxt
    end

    return false
end

def shuffle(input, n)
    cache = {}
    prev_node = nil

    input.each do |i|
        node = Node.new(i)
        cache[i] = node

        if prev_node
            prev_node.link(node)
        end

        prev_node = node
    end

    node = prev_node

    max_value = input.max

    n.times do |move|
        node = node.nxt
        pick_up = node.unlink(3)
        dst_value = node.value - 1

        loop do 
            if dst_value < 1
                dst_value = max_value
            end

            if contains_value(pick_up, 3, dst_value)
                dst_value -= 1 
            else
                break
            end
        end

        cache[dst_value].link(pick_up)
    end

    return cache[1]
end

def pad(input, n)
    input = input.dup
    initial_size = input.size
    additional_positions = n - input.size

    additional_positions.times do |i|
        ii = i + initial_size + 1
        input[ii-1] = ii
    end

    return input
end

input = File.read(ARGV[0]).strip.chars.map(&:to_i)

node = shuffle(input, 100)
output = ""
loop do
    node = node.nxt

    output += node.value.to_s

    break if node.nxt.value == 1
end

p output

node = shuffle(pad(input, 1000000), 10000000)

first = node.nxt.value
second = node.nxt.nxt.value

p first * second
