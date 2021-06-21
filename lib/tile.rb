# Handles initialization and logic for each tile on the game board
#     Copyright (C) 2021  Thomas Pierce Bosley

#     This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.

#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.

#     You should have received a copy of the GNU General Public License
#     along with this program.  If not, see <https://www.gnu.org/licenses/>.

# I can be reached by email at pierce-bosley@gmail.com

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
