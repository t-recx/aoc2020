#!/usr/bin/env ruby

input = File
    .read(ARGV[0])

rules = input
    .split('your ticket')[0]
    .split("\n")
    .map { |x| x.split(' ') }
    .map { |x| [x[1], x[3]] }
    .map { |a, b| [a.split('-'), b.split('-')] }

values = input
    .split("nearby tickets:")[1]
    .strip
    .gsub("\n", ",")
    .split(',')
    .map(&:to_i)

error_rate = 0

invalid_values = []

values.each do |value|
    passed = false

    rules.each do |rule|
        if value.between? rule[0][0].to_i, rule[0][1].to_i or value.between? rule[1][0].to_i, rule[1][1].to_i
            passed = true
        end
    end

    if not passed
        error_rate += value 
        invalid_values.push value
    end
end

p error_rate

rules = input
    .split('your ticket')[0]
    .split("\n")
    .map { |x| x.split(':') }
    .map { |x| [x[0], x[1]] }
    .map { |name, rules| [name, rules.split(' ')]}
    .map { |name, rules| [name, rules[0].split('-').map(&:to_i), rules[2].split('-').map(&:to_i)]}

my_ticket = input.split('your ticket:')[1].strip.split("\n")[0].split(',').map(&:to_i)

nearby_tickets = input
    .split('nearby tickets:')[1].strip.split("\n")
    .map { |x| x.split(',') }.map { |x| x.map(&:to_i) }

valid_tickets = nearby_tickets
    .reject { |x| x.any? { |y| invalid_values.include? y }}

valid_tickets.push my_ticket

rule_column = {}
available_columns = (0..rules.size-1).to_a
departure_rules = rules
    .select { |x| x[0].start_with? 'departure'}

loop do
    (0..rules.size-1).each do |column|
        next if rule_column.any? { |_, v| v == column}

        rules.each do |name, fc, sc|
            next if rule_column[name]

            if valid_tickets.all? { |ticket| ticket[column].between?(fc[0], fc[1]) or ticket[column].between?(sc[0], sc[1])}
                if not rules
                    .reject { |x| x[0] == name }
                    .reject { |x| rule_column.keys.include? x[0] }
                    .any? { |_, ofc, osc| 
                        valid_tickets.all? { |ticket| ticket[column].between?(ofc[0], ofc[1]) or ticket[column].between?(osc[0], osc[1])} }
                    rule_column[name] = column
                    break
                end
            end
        end
    end

    break if rule_column.keys.select { |x| x.start_with? 'departure'}.size == departure_rules.size
end

p my_ticket
    .each_with_index
    .select { |n, i| rule_column.select { |k, _| k.start_with? 'departure'}.values.include? i }
    .map { |n, i| n}
    .reduce(:*)