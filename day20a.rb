#!/usr/bin/env ruby

tiles = File.read(ARGV[0])
 .split("\n\n")
 .map { |x| x.split("\n") }
 .map { |x| [x[0].sub('Tile ', '').sub(':', '').to_i, x[1..-1]]}
 .to_h { |t, x| [t, [x[0], x[-1], x.map { |y| y.chars[0] }.join, x.map { |y| y.chars[-1] }.join]]}

def check_valid(tile, neighbour, visited)
    visited[tile] = {} if not visited[tile]
    visited[neighbour] = {} if not visited[neighbour]

    if visited[tile][neighbour] == nil 
        visited[tile][neighbour] = tile.any? { |a| neighbour.any? {|b| a == b}} || tile.map { |s| s.reverse }.any? { |a| neighbour.any? {|b| a == b}}
        visited[neighbour][tile] = visited[tile][neighbour]
    end

    return visited[tile][neighbour]
end

visited = {}

corners = {}

tiles.keys
.each do |key|
    other_keys = tiles.keys.reject { |k| k == key  }

    possible = 0

    other_keys.each do |other_key|
        possible += 1 if check_valid(tiles[key], tiles[other_key], visited)

        break if possible > 2
    end

    corners[key] = tiles[key] if possible == 2

    if corners.size == 4
        p corners.keys.reduce(:*)
        return
    end
end


