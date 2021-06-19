module Minesweeper
  class Tile
    attr_reader :hidden, :flagged

    def initialize(bomb)
      @adjacent_bombs = nil
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
