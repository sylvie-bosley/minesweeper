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

require "yaml"
require_relative "tile"

module Minesweeper
  class Board
    def initialize(dimensions, mines)
      @rows = dimensions.first
      @cols = dimensions.last
      @grid = build_grid(mines)
      @mines = mines
      @flags = 0
    end

    def render
      line = "\u203E"
      col_width, board_width, display_width = generate_formatting_widths
      columns_label = generate_cols_label(col_width, display_width)
      board_top = "#{"_" * (board_width)}"
      board_bottom = "#{line.force_encoding("utf-8") * (board_width)}"
      remaining_mines = "#{@mines - @flags} mines remain"

      system("clear")

      puts columns_label
      puts board_top.rjust(display_width)

      @grid.each_with_index do |row, index|
        puts "#{index.to_s.rjust(2)} |#{parse_row(row, col_width)}|"
      end

      puts board_bottom.rjust(display_width)
      puts remaining_mines.center(display_width)
      puts
    end

    def toggle_flag(position)
      tile = self[position]

      if tile.toggle_flag
        if tile.flagged
          @flags += 1
        else
          @flags -= 1
        end
      end

      tile.to_s
    end

    def reveal(position)
      tile = self[position]

      if tile.reveal && tile.will_cascade?
        cascade_reveal(position)
      end

      tile.to_s
    end

    def valid_position?(position)
      row, col = position
      (0...@rows).include?(row) && (0...@cols).include?(col)
    end

    def all_mines_found?
      safe_tiles = (@rows * @cols) - @mines
      safe_tiles == @grid.inject(0) { |acc, row| acc + row.count(&:revealed) }
    end

    def save_game(save_name)
      File.open("save_games/#{save_name}.sav", "w") do |save_file|
        YAML.dump(self, save_file)
      end
    end

    private

    def generate_formatting_widths
      if @cols < 10
        col_width = 2
      else
        col_width = 3
      end

      board_width = col_width * (@cols - 1) + 3
      display_width = board_width + 3

      [col_width, board_width, display_width]
    end

    def generate_cols_label(col_width, display_width)
      label = (0...@cols).to_a.map do |label|
        label.to_s.rjust(col_width)
      end

      label.join.rjust(display_width - 1)
    end

    def parse_row(row, col_width)
      parsed_row = row.map.with_index do |tile, col_index|
        if col_index.zero?
          tile.to_s
        else
          tile.to_s.rjust(col_width) unless col_index.zero?
        end
      end
      parsed_row.join
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
