module Minesweeper
  class Tile
    HIDDEN = "#"
    EMPTY = " "
    private_constant :HIDDEN

    attr_reader :revealed, :flagged, :bomb

    def initialize(bomb)
      @adjacent_bombs = 0
      @revealed = false
      @flagged = false
      @bomb = bomb
    end

    def reveal!(adjacent_bombs)
      @revealed = true
      @adjacent_bombs = adjacent_bombs
    end

    def to_s
      return HIDDEN unless @revealed
      return EMPTY if @adjacent_bombs.zero?
      @adjacent_bombs.to_s
    end
  end
end
