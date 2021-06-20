module Minesweeper
  class Tile
    HIDDEN = "#"
    EMPTY = " "

    attr_writer :adjacent_mines
    attr_reader :revealed, :flagged, :mine

    def initialize(mine)
      @adjacent_mines = 0
      @revealed = false
      @flagged = false
      @mine = mine
    end

    def reveal(adjacent_mines)
      @revealed = true
      @adjacent_mines = adjacent_mines
    end

    def toggle_flag
      @flagged = !@flagged
    end

    def to_s
      return HIDDEN unless @revealed
      return EMPTY if @adjacent_mines.zero?
      @adjacent_mines.to_s
    end
  end
end
