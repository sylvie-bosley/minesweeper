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

require "colorize"

module Minesweeper
  class Tile
    MINE = " @ ".black.on_light_black.freeze

    HIDDEN = "   ".black.on_white.freeze
    EMPTY = "   ".on_light_black.freeze
    FLAG = " F ".light_red.on_white.freeze
    private_constant :HIDDEN, :EMPTY, :FLAG

    attr_reader :adjacent_mines, :revealed, :flagged, :mine

    def initialize(adjacent_mines, mine)
      @adjacent_mines = adjacent_mines
      @revealed = false
      @flagged = false
      @mine = mine
    end

    def inspect
      {
        'adjacent_mines' => @adjacent_mines,
        'flagged' => @flagged,
        'mine' => @mine,
        'revealed' => @revealed
      }.inspect
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
      colorized_number(@adjacent_mines.to_s.center(3)).on_light_black
    end

    private

    def colorized_number(tile_string)
      case tile_string[1].to_i
      when 1
        tile_string.light_blue
      when 2
        tile_string.light_green
      when 3
        tile_string.light_red
      when 4
        tile_string.magenta
      when 5
        tile_string.red
      when 6
        tile_string.cyan
      when 7
        tile_string.black
      when 8
        tile_string.white
      else
        nil
      end
    end
  end
end
