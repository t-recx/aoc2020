#!/usr/bin/env ruby

def common(raw)
    group = raw.split
    participants = group.count
    unique_chars = raw.delete("\n").chars.uniq
    answers = []

    unique_chars.each do |c|
        answers.push group.select { |p| p.include? c }.count
    end

    return answers.select { |a| a == participants }.count
end

p File.read(ARGV[0]).split("\n\n").map { |group| common(group) }.sum