#!/usr/bin/env ruby

alergens_foods = File
    .readlines(ARGV[0])
    .map(&:strip)
    .map { |x| x.gsub(')', '').split('(contains') }
    .map { |x, y| [y.gsub(' ', '').split(','), x.split] }

alergens = alergens_foods.map { |x, y| x }.reduce(:+).uniq.to_h { |x| [x, nil] }

alergens_foods.each do |alergens_food, ingredients|
    alergens_food.each do |alergen|
        if alergens[alergen]
            alergens[alergen] = alergens[alergen] & ingredients
        else
            alergens[alergen] = ingredients
        end
    end
end

loop do 
    alergens.each do |alergen, ingredients|
        if ingredients.size == 1
            alergens
            .select { |x, _| x != alergen }
            .select { |x, y| y.include? ingredients.first }
            .each do |x, y| 
                y.reject! { |z| z == ingredients.first }
            end 
        end
    end

    break if alergens.all? { |_, i| i.size == 1 }
end

p alergens_foods.flat_map { |_, y| y }.reject { |y| alergens.any? { |_, z| z.include? y } }.count 

p alergens.sort_by { |x, _| x }.flat_map { |_, y| y }.uniq.join(',')