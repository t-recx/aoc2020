#!/usr/bin/env ruby

def pieces_interlock(tile, neighbour)
    [tile, mirror(tile)].any? { |t| t.any? { |border| neighbour.any? { |nborder| border == nborder } } }
end

def mirror(piece)
    piece.map(&:reverse)
end

def rotate_right(piece)
    piece.map(&:chars).transpose.map(&:reverse).map(&:join)
end

def get_border_right(piece)
    piece.map { |y| y.chars[-1] }.join
end

def get_border_down(piece)
    piece[-1]
end

def get_border_left(piece)
    piece.map { |y| y.chars[0] }.join
end

def get_border_up(piece)
    piece[0]
end

def get_operations
    ['n', 'r', 'r', 'r', 'm', 'r', 'r', 'r']
end

def transform(piece, operation)
    if operation == 'r'
        return rotate_right(piece)
    elsif operation == 'm'
        return mirror(piece)
    end

    piece
end

def transform_neighbour(piece, piece_neighbour, ox, oy)
    piece_border = nil
    piece_neighbour_border = nil

    if ox > 0
        piece_border = get_border_right(piece)
    elsif oy > 0
        piece_border = get_border_down(piece)
    end

    get_operations.each do |operation|
        piece_neighbour = transform(piece_neighbour, operation)

        if ox > 0
            piece_neighbour_border = get_border_left(piece_neighbour)
        elsif oy > 0
            piece_neighbour_border = get_border_up(piece_neighbour)
        end

        return piece_neighbour if piece_neighbour_border == piece_border
    end

    nil
end

def already_allocated(pieces, neighbour_key, x, y)
    [[-1, 0], [1, 0], [0, -1], [0, 1]].each do |ox, oy|
        next if x - ox < 0
        next if y - oy < 0

        return true if pieces[y + oy] and pieces[y + oy][x + ox] and pieces[y + oy][x + ox][0] == neighbour_key
    end

    false
end

def get_top_left_corner(corners, tiles_pieces, tiles_neighbours, square_side_size)
    corners.each do |corner|
        pieces = { 0 => { 0 => [corner[0], tiles_pieces[corner[0]]], 1 => nil }, 1 => { 0 => nil } }

        tiles_neighbours[pieces[0][0][0]].each do |neighbour_key|
            [[1, 0], [0, 1]].each do |ox, oy|
                if not pieces[oy][ox]
                    transformed = transform_neighbour(pieces[0][0][1], tiles_pieces[neighbour_key], ox, oy)

                    if transformed
                        pieces[oy][ox] = [neighbour_key, transformed]
                        break
                    end
                end
            end
        end

        return corner if pieces[0][1] and pieces[1][0]
    end
end

def remove_borders(piece)
    piece[1..-2].map { |c| c[1..-2] }
end

def count_sea_monsters(piece, sea_monster)
    monsters = 0

    sea_monster = sea_monster.map { |x| x.gsub(' ', '.') }

    width = sea_monster[0].size
    height = sea_monster.size

    (piece.size - height).times do |y|
        (piece[y].size - width).times do |x|
            if (0..height-1).all? { |oy| piece[y + oy][x..(x + width)].match(/^#{sea_monster[oy]}/)}
                monsters += 1
            end
        end
    end

    monsters
end

def get_tiles_neighbours(tiles)
    tiles_neighbours = {}

    tiles.keys.each do |key|
        tiles_neighbours[key] = [] 

        other_keys = tiles.keys.reject { |k| k == key  }

        other_keys.each do |other_key|
            if pieces_interlock(tiles[key], tiles[other_key])
                tiles_neighbours[key].push other_key
            end
        end
    end

    tiles_neighbours
end

def get_solved_puzzle(tiles, tiles_pieces)
    tiles_neighbours = get_tiles_neighbours(tiles)

    corners = tiles_neighbours.select { |k, v| v.size == 2 }

    square_side_size = Math.sqrt(tiles.size).to_i

    pieces = {}

    square_side_size.times { |y| pieces[y] = {} }

    top_left_corner = get_top_left_corner(corners, tiles_pieces, tiles_neighbours, square_side_size)[0]

    pieces[0][0] = [top_left_corner, tiles_pieces[top_left_corner]]

    (square_side_size).times do |y|
        (square_side_size).times do |x|
            key = pieces[y][x][0]
            piece = pieces[y][x][1]

            tiles_neighbours[key].each do |neighbour_key|
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

    pieces
end

def remove_borders_from_pieces(pieces, tiles)
    width = pieces[0][0][1][0].size - 2
    height = pieces[0][0][1].size - 2

    square_side_size = Math.sqrt(tiles.size).to_i

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

    final_image.map { |_, v| v.sort_by { |k, _| k }.map { |_, vv| vv }.join }
end

def is_corner(key, tiles)
    number_tiles_interlocked = 0

    (tiles.keys - [key]).each do |other_key|
        number_tiles_interlocked += 1 if pieces_interlock(tiles[key], tiles[other_key])

        break if number_tiles_interlocked > 2
    end

    return number_tiles_interlocked == 2
end

def part_a(tiles)
    corners = {}

    tiles.keys.each do |key|
        if is_corner(key, tiles)
            corners[key] = tiles[key] 

            return corners.keys.reduce(:*) if corners.size == 4
        end
    end
end

def part_b(tiles, input)
    sea_monster = [ "                  # ",
                    "#    ##    ##    ###",
                    " #  #  #  #  #  #   "]

    tiles_pieces = input.to_h { |x| [x[0].sub('Tile ', '').sub(':', '').to_i, x[1..-1]]}

    final_piece = remove_borders_from_pieces(get_solved_puzzle(tiles, tiles_pieces), tiles)

    get_operations.each do |operation|
        final_piece = transform(final_piece, operation)

        sea_monster_number = count_sea_monsters(final_piece, sea_monster)

        if sea_monster_number > 0
            return final_piece.sum { |x| x.count('#') } - sea_monster_number * sea_monster.sum { |x| x.count('#')}
        end
    end
end

def get_piece_borders(piece)
    [get_border_up(piece), get_border_down(piece), get_border_left(piece), get_border_right(piece)]
end

input = File.read(ARGV[0]).split("\n\n").map { |x| x.split("\n") }

tiles = input
        .map { |x| [x[0].sub('Tile ', '').sub(':', '').to_i, x[1..-1]]}
        .to_h { |t, x| [t, get_piece_borders(x)]}

p part_a(tiles)
p part_b(tiles, input)
