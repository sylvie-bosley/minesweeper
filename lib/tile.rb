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
      if @flagged || @revealed
        return false
      else
        @revealed = true
      end
    end

    def toggle_flag
      if @revealed
        return false
      else
        @flagged = !@flagged
        true
      end
    end

    def will_cascade?
      !mine && @adjacent_mines.zero?
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
