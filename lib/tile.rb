module Minesweeper
  class Tile
    HIDDEN = "#"
    EMPTY = " "
    MINE = "@"
    private_constant :HIDDEN, :EMPTY, :MINE

    attr_reader :adjacent_mines, :revealed, :flagged, :mine

    def initialize(adjacent_mines, mine)
      @adjacent_mines = adjacent_mines
      @revealed = false
      @flagged = false
      @mine = mine
    end

    def reveal
      @revealed = true
    end

    def toggle_flag
      @flagged = !@flagged
    end

    def can_be_revealed?
      @adjacent_mines.zero? && !@revealed && !@flagged && !@mine
    end

    def to_s
      return HIDDEN unless @revealed
      return MINE if @mine
      return EMPTY if @adjacent_mines.zero?
      @adjacent_mines.to_s
    end
  end
end
