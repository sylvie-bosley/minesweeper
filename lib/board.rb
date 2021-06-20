module Minesweeper
  class Board
    def initialize(tiles)
      @grid = tiles
    end

    def [](position)
      row, col = position
      @grid[row][col]
    end
  end
end
