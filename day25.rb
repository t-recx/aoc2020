#!/usr/bin/env ruby

def transform(subject, loop_size)
    value = 1

    loop_size.times do |n|
        value *= subject
        value = value % 20201227
    end

    return value
end

def get_loop_size(key)
    value = 1
    subject = 7

    n = 1
    loop do
        value *= subject
        value = value % 20201227

        if value == key
            return n
        end
        n += 1
    end
end

card, door = File.readlines(ARGV[0]).map(&:to_i)

loop_size_card = get_loop_size(card)

p transform(door, loop_size_card)
