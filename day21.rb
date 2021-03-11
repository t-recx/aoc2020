#!/usr/bin/env ruby

alergens_foods = File
    .readlines(ARGV[0])
    .map(&:strip)
    .map { |x| x.gsub(')', '').split('(contains') }
    .map { |x, y| [y.gsub(' ', '').split(','), x.split] }

alergens = alergens_foods.map { |x, _| x }.reduce(:+).uniq.to_h { |x| [x, nil] }

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
            .select { |_, y| y.include? ingredients.first }
            .each do |_, y| 
                y.reject! { |z| z == ingredients.first }
            end 
        end
    end

    break if alergens.all? { |_, i| i.size == 1 }
end

p alergens_foods.flat_map { |_, y| y }.count { |y| alergens.none? { |_, z| z.include? y } } 

p alergens.sort_by { |x, _| x }.flat_map { |_, y| y }.uniq.join(',')