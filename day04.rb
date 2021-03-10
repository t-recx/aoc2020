#!/usr/bin/env ruby

def get_valid_passports(input)
    input.select { |line| ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid'].all? { |key| line.include? key } }
end

def valid?(key, value) 
    if key == 'byr'
        value.to_i.between? 1920, 2002
    elsif key == 'iyr'
        value.to_i.between? 2010, 2020
    elsif key == 'eyr'
        value.to_i.between? 2020, 2030
    elsif key == 'hgt'
        return value.to_i.between?(150, 193) if value.end_with? 'cm'
        return value.to_i.between?(59, 76) if value.end_with? 'in'
        
        false
    elsif key == 'hcl'
        /#([0-9]|[a-f]){6}/.match?(value)
    elsif key == 'ecl'
        ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'].any? value
    elsif key == 'pid'
        value.size == 9 && /([0-9]){9}/.match?(value)
    else
        true
    end
end

valid_passports = get_valid_passports(File.read(ARGV[0]).split("\n\n"))

p valid_passports.count

p valid_passports.count { |line| line.split.all? { |kvp| valid?(*kvp.split(':')) } }
