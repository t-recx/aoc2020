#!/usr/bin/env ruby

input = File.read(ARGV[0]).split("\n\n")

def get_message_count(rules, messages, imax)
    last_message_count = 0

    rules_to_evaluate = rules.dup
    final_rules = false

    loop do 
        to_replace = rules_to_evaluate.select { |_, v| ('0'..'9').none? { |c| v.include? c } }

        if to_replace.size == 0
            to_replace = rules_to_evaluate.select {|k, _| k == "8" || k == "11" }

            final_rules = true
        end

        to_replace.each do |k, v|
            rules.each do |rk, rv|
                i = 0

                loop do 
                    rv.gsub!(' ' + k + ' ', ' (' + v + ') ')

                    break if final_rules and i > imax 
                    break unless rv.include? ' ' + k + ' ' 

                    i += 1
                end
            end
        end

        rules_to_evaluate.reject! { |k, _| to_replace[k] }

        break if rules_to_evaluate.size == 0 or final_rules
    end

    rule = rules["0"].gsub(' ', '').gsub('(a)', 'a').gsub('(b)', 'b').gsub('(aa)', 'aa').gsub('(bb)', 'bb').gsub('(ab)', 'ab').gsub('(ba)', 'ba') + ' '

    return messages.count { |m| m.match(/^#{rule}/) }
end

messages = input[1].split("\n").map { |x| x + ' '}

input_rules = input[0].split("\n").map { |x| x.split(":") }.to_h { |x| [x[0], x[1].gsub('"', '') + ' ' ] }

last_message_count = 0

imax = 0

loop do 
    message_count = get_message_count(input_rules.to_h {|k, v| [k, v.dup] }, messages, imax)

    return p message_count if message_count == last_message_count

    last_message_count = message_count
    imax += 1
end