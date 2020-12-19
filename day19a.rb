#!/usr/bin/env ruby

input = File.read(ARGV[0]).split("\n\n")

rules = input[0].split("\n").map { |x| x.split(":") }.to_h { |x| [x[0], x[1].gsub('"', '') ] }

rules_to_evaluate = rules.dup

loop do 
    to_replace = rules_to_evaluate.select { |_, v| ['a', 'b'].any? { |c| v.include? c } }

    to_replace.each do |k, v|
        rules.each do |rk, rv|
            rv.gsub!(k, v)
            rv.gsub!('  ', ' ')
        end
    end

    rules_to_evaluate.reject! { |k, _| to_replace[k] }

    break if rules_to_evaluate.size == 0
end

rules = rules.map { |k, v| [k, v.gsub(' ', '')] }
p rules[0]