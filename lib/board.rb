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

      unless tile.revealed
        tile.toggle_flag
        @flags += 1 if tile.flagged
        @flags -= 1 unless tile.flagged
      end

      tile.to_s
    end

    def reveal(position)
      tile = self[position]

      unless tile.flagged || tile.revealed
        tile.reveal
        cascade_reveal(position) unless tile.adjacent_mines > 0 || tile.mine
      end

      tile.to_s
    end

    private

    def cascade_reveal(tile_position)
      neighbor_positions = find_neighbors(tile_position)

      neighbor_positions.each do |neighbor_position|
        current_tile = self[neighbor_position]

        if current_tile.can_be_revealed?
          current_tile.reveal
          cascade_reveal(neighbor_position) if current_tile.adjacent_mines.zero?
        end
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
