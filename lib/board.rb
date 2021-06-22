# Handles the logic of creating and running the board
#     Copyright (C) 2021  Thomas Pierce Bosley

#     This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.

#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.

#     You should have received a copy of the GNU General Public License
#     along with this program.  If not, see <https://www.gnu.org/licenses/>.

# I can be reached by email at pierce-bosley@gmail.com

require_relative "tile"

module Minesweeper
  class Board
    COLUMN_WIDTH = 3
    private_constant :COLUMN_WIDTH

    def initialize(dimensions, mines)
      @rows = dimensions.first
      @cols = dimensions.last
      @grid = build_grid(mines)
      @mines = mines
      @flags = 0
      @cursor_position = [0, 0]
    end

    def render
      columns_label = generate_cols_label(display_width)
      board_side = "|".black.on_white
      divider_row = "   " << "|#{"---|" * @cols}".black.on_white
      remaining_mines = "#{@mines - @flags} mines remain"

      system "clear"

      puts columns_label

      @grid.each_with_index do |row, row_index|
        puts divider_row
        board_row = "#{board_side}#{parse_row(row, row_index)}#{board_side}"
        puts "#{row_index.to_s.rjust(2)} #{board_row}"
      end
      puts divider_row

      puts remaining_mines.center(display_width)
      puts
    end

    def toggle_flag
      tile = self[@cursor_position]

      if tile.toggle_flag
        if tile.flagged
          @flags += 1
        else
          @flags -= 1
        end
      end

      tile.to_s
    end

    def reveal(position = @cursor_position)
      tile = self[position]

      if tile.reveal && tile.will_cascade?
        cascade_reveal(position)
      end

      tile.to_s
    end

    def all_mines_found?
      safe_tiles = (@rows * @cols) - @mines
      safe_tiles == @grid.inject(0) { |acc, row| acc + row.count(&:revealed) }
    end

    def move_cursor(direction)
      case direction
      when :up
        cursor_up
      when :down
        cursor_down
      when :left
        cursor_left
      when :right
        cursor_right
      else
        nil
      end
    end

    private

    def cursor_up
      @cursor_position = [
        [@cursor_position.first - 1, 0].max,
        @cursor_position.last
      ]
    end

    def cursor_down
      @cursor_position = [
        [@cursor_position.first + 1, @rows - 1].min,
        @cursor_position.last
      ]
    end

    def cursor_left
      @cursor_position = [
        @cursor_position.first,
        [@cursor_position.last - 1, 0].max
      ]
    end

    def cursor_right
      @cursor_position = [
        @cursor_position.first,
        [@cursor_position.last + 1, @cols - 1].min
      ]
    end

    def display_width
      board_width = (@cols * COLUMN_WIDTH) + (@cols + 1)
      board_width + 3
    end

    def generate_cols_label(display_width)
      label = (0...@cols).to_a.map do |label|
        label.to_s.rjust(COLUMN_WIDTH + 1)
      end

      label.join.rjust(display_width - 2)
    end

    def parse_row(row, row_index)
      parsed_row = row.map.with_index do |tile, col_index|
        if @cursor_position == [row_index, col_index]
          ">#{tile.to_s.uncolorize[1]}<"
        else
          tile.to_s
        end
      end.join("|".black.on_white)
    end

    def cascade_reveal(tile_position)
      neighbor_positions = find_neighbors(tile_position)

      neighbor_positions.each do |neighbor_position|
        next if self[neighbor_position].mine
        reveal(neighbor_position)
      end
    end

    def find_neighbors(position)
      row, col = position
      neighbors = []

      (-1..1).each do |row_offset|
        (-1..1).each do |col_offset|
          neighbors << [
            [
              [0, row + row_offset].max,
              @rows - 1
            ].min,
            [
              [0, col + col_offset].max,
              @cols - 1
            ].min
          ]
        end
      end

      neighbors.uniq - [position]
    end

    def [](position)
      row, col = position
      @grid[row][col]
    end

    def build_grid(mines)
      new_grid = Array.new(@rows) { Array.new(@cols) }
      mine_positions = generate_mine_positions(mines)

      @rows.times do |row|
        @cols.times do |col|
          new_grid[row][col] = create_tile([row, col], mine_positions)
        end
      end

      new_grid
    end

    def generate_mine_positions(mines)
      positions = []

      until positions.length == mines
        new_position = [rand(@rows), rand(@cols)]
        positions << new_position unless positions.include?(new_position)
      end

      positions
    end

    def create_tile(position, mine_positions)
      adjacent_mines = count_adjacent_mines(position, mine_positions)

      if mine_positions.include?(position)
        Tile.new(adjacent_mines, true)
      else
        Tile.new(adjacent_mines, false)
      end
    end

    def count_adjacent_mines(position, mine_positions)
      neighbor_positions = find_neighbors(position)

      neighbor_positions.count do |neighbor_position|
        mine_positions.include?(neighbor_position)
      end
    end
  end
end
