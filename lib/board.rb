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

    def toggle_flag(position)
      tile = self[position]
      if tile.revealed
        puts "Cannot flag a revealed tile!"
      else
        tile.toggle_flag
        @flags += 1 if tile.flagged
        @flags -= 1 unless tile.flagged
      end
    end

    private

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
          if mine_positions.include?([row, col])
            new_grid[row][col] = Tile.new(true)
          else
            new_grid[row][col] = Tile.new(false)
          end
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
  end
end
