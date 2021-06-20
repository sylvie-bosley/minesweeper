module Minesweeper
  class Tile
    HIDDEN = "#"
    EMPTY = " "
    MINE = "@"
    FLAG = "?"
    private_constant :HIDDEN, :EMPTY, :MINE, :FLAG

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
      !@revealed && !@flagged && !@mine
    end

    def to_s
      return FLAG if @flagged
      return HIDDEN unless @revealed
      return MINE if @mine
      return EMPTY if @adjacent_mines.zero?
      @adjacent_mines.to_s
    end
  end
end
