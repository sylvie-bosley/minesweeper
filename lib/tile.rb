module Minesweeper
  class Tile
    attr_reader :hidden, :flagged, :bomb

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
  end
end
