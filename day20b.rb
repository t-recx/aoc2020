#!/usr/bin/env ruby

tiles = File.read(ARGV[0])
 .split("\n\n")
 .map { |x| x.split("\n") }
 .map { |x| [x[0].sub('Tile ', '').sub(':', '').to_i, x[1..-1]]}
 .to_h { |t, x| [t, [x[0], x[-1], x.map { |y| y.chars[0] }.join, x.map { |y| y.chars[-1] }.join]]}

tiles_pieces = File.read(ARGV[0])
 .split("\n\n")
 .map { |x| x.split("\n") }
 .to_h { |x| [x[0].sub('Tile ', '').sub(':', '').to_i, x[1..-1]]}

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

tiles_neighbours = {}

tiles.keys
.each do |key|
    tiles_neighbours[key] = [] 

    other_keys = tiles.keys.reject { |k| k == key  }

    other_keys.each do |other_key|
        if check_valid(tiles[key], tiles[other_key], visited)
            tiles_neighbours[key].push other_key
        end
    end
end

def mirror(piece)
    piece.map { |x| x.reverse }
end

def rotate_right(piece)
    return piece.map { |x| x.chars }.transpose.map { |c| c.reverse }.map { |c| c.join }
end

def get_border_right(piece)
    return piece.map { |y| y.chars[-1] }.join
end

def get_border_down(piece)
    return piece[-1]
end

def get_border_left(piece)
    return piece.map { |y| y.chars[0] }.join
end

def get_border_up(piece)
    return piece[0]
end

def transform_neighbour(piece, piece_neighbour, ox, oy)

    piece_border = nil
    piece_neighbour_border = nil

    if ox > 0
        piece_border = get_border_right(piece)
    end

    if oy > 0
        piece_border = get_border_down(piece)
    end

    ['n', 'r', 'r', 'r', 'm', 'r', 'r', 'r'].each do |operations|
        operations.chars.each do |operation|
            if operation == 'r'
                piece_neighbour = rotate_right(piece_neighbour)
            end

            if operation == 'm'
                piece_neighbour = mirror(piece_neighbour)
            end

            if ox > 0
                piece_neighbour_border = get_border_left(piece_neighbour)
            end

            if oy > 0
                piece_neighbour_border = get_border_up(piece_neighbour)
            end

            if piece_neighbour_border == piece_border
                return piece_neighbour
            end
        end
    end

    return nil
end

def already_allocated(pieces, neighbour_key, x, y)
    [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |ox, oy|
        next if x - ox < 0
        next if y - oy < 0

        return true if pieces[y + oy] and pieces[y + oy][x + ox] and pieces[y + oy][x + ox][0] == neighbour_key
    end

    return false
end

def get_top_left_corner(corners, tiles_pieces, tiles_neighbours, square_side_size)
    corners = tiles_neighbours.select { |k, v| v.size == 2}

    corners.each do |corner|
        pieces = {}
        pieces[0] = {}
        pieces[1] = {}
        pieces[0][0] = [corner[0], tiles_pieces[corner[0]]]
        pieces[0][1] = nil
        pieces[1][0] = nil

        x = 0
        y = 0

        if pieces[y][x] 
            key = pieces[y][x][0]
            piece = pieces[y][x][1]
            neighbours_keys = tiles_neighbours[key]

            neighbours_keys.each do |neighbour_key|
                next if already_allocated(pieces, neighbour_key, x, y)

                [[1, 0], [0, 1]].each do |ox, oy|
                    if not pieces[y + oy][x + ox]
                        transformed = transform_neighbour(piece, tiles_pieces[neighbour_key], ox, oy)

                        if transformed
                            pieces[y + oy][x + ox] = [neighbour_key, transformed]
                            break
                        end
                    end
                end
            end

            return corner if pieces[0][1] and pieces[1][0]
        end
    end
end

def remove_borders(piece)
    piece[1..-2].map { |c| c[1..-2] }
end

corners = tiles_neighbours.select { |k, v| v.size == 2}

square_side_size = Math.sqrt(tiles.size).to_i

pieces = {}
square_side_size.times { |y| pieces[y] = {} }

starter_square = get_top_left_corner(corners, tiles_pieces, tiles_neighbours, square_side_size)

pieces[0][0] = [starter_square[0], tiles_pieces[starter_square[0]]]

(square_side_size).times do |y|
    (square_side_size).times do |x|
        if pieces[y][x] 
            key = pieces[y][x][0]
            piece = pieces[y][x][1]
            neighbours_keys = tiles_neighbours[key]

            keys_to_allocate = neighbours_keys

            keys_to_allocate.each do |neighbour_key|
                next if already_allocated(pieces, neighbour_key, x, y)

                [[1, 0], [0, 1]].each do |ox, oy|
                    next if y + oy >= square_side_size
                    next if x + ox >= square_side_size

                    if not pieces[y + oy][x + ox]
                        transformed = transform_neighbour(piece, tiles_pieces[neighbour_key], ox, oy)

                        if transformed
                            pieces[y + oy][x + ox] = [neighbour_key, transformed]
                            break
                        end
                    end
                end
            end
        end
    end
end

width = pieces[0][0][1][0].size - 2
height = pieces[0][0][1].size - 2

final_image = {}
(square_side_size).times do |y|
    (square_side_size).times do |x|
        piece = remove_borders(pieces[y][x][1])
        height.times do |py|
            final_image[y*height + py] = {} if not final_image[y*height + py]
            width.times do |px|
                final_image[y*height + py][x*width + px] = piece[py][px]
            end
        end
    end
end

final_piece = []
final_image.each do |y, v|
    final_piece.push v.sort_by { |k, vv| k }.map { |k, vv| vv }.join
end

def count_sea_monsters(piece, sea_monster)
    monsters = 0

    sea_monster = sea_monster.map { |x| x.gsub(' ', '.') }

    width = sea_monster[0].size
    height = sea_monster.size

    (piece.size - height).times do |y|
        (piece[y].size - width).times do |x|
            substr_range = x..(x + width) 
            if piece[y][substr_range].match(/^#{sea_monster[0]}/) and
                piece[y+1][substr_range].match(/^#{sea_monster[1]}/) and
                piece[y+2][substr_range].match(/^#{sea_monster[2]}/) and
                monsters += 1
            end
        end
    end

    return monsters
end

sea_monster = [ "                  # ",
                "#    ##    ##    ###",
                " #  #  #  #  #  #   "]

['n', 'r', 'r', 'r', 'm', 'r', 'r', 'r'].each do |operations|
    operations.chars.each do |operation|
        if operation == 'r'
            final_piece = rotate_right(final_piece)
        end

        if operation == 'm'
            final_piece = mirror(final_piece)
        end

        sea_monster_number = count_sea_monsters(final_piece, sea_monster)

        if sea_monster_number > 0
            return p final_piece.map { |x| x.count('#') }.sum - sea_monster_number * sea_monster.map { |x| x.count('#')}.sum
        end
    end
end

