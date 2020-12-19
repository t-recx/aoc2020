#!/usr/bin/env ruby

input = File.read(ARGV[0]).split("\n\n")

messages = input[1].split("\n").map { |x| x + ' '}

rules = input[0].split("\n").map { |x| x.split(":") }.to_h { |x| [x[0], x[1].gsub('"', '') + ' ' ] }

rules_to_evaluate = rules.dup

loop do 
    to_replace = rules_to_evaluate.select { |_, v| ('0'..'9').none? { |c| v.include? c } }

    to_replace.each do |k, v|
        rules.each do |rk, rv|
            loop do 
                rv.gsub!(' ' + k + ' ', ' (' + v + ') ')

                break unless rv.include? ' ' + k + ' '
            end
        end
    end

    rules_to_evaluate.reject! { |k, _| to_replace[k] }

    break if rules_to_evaluate.size == 0
end

rule = rules["0"].gsub(' ', '').gsub('(a)', 'a').gsub('(b)', 'b').gsub('(aa)', 'aa').gsub('(bb)', 'bb').gsub('(ab)', 'ab').gsub('(ba)', 'ba') + ' '

p messages.count { |m| m.match(/^#{rule}/) }