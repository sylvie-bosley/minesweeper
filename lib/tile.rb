module Minesweeper
  class Tile
    attr_reader :hidden, :flagged

    def initialize(bomb)
      @revealed = false
      @flagged = false
      @bomb = bomb
    end

    def reveal!
      @revealed = true
    end
  end
end
