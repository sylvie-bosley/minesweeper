# Handles the logic of managing the game state and interacting with the player
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

require "remedy"
require_relative "board"
require_relative "save_load"

module Minesweeper
  class MineGame
    include SaveLoad

    SAVE_FOLDER = "saved_games/"
    SAVE_EXT = ".sav"
    DIFFICULTY_LEVELS = {
      beginner: [[9, 9], 10],
      intermediate: [[16, 16],	40],
      expert: [[16,	30],	99],
    }
    VALID_YESNO = ["yes", "y", "no", "n"]
    COMMANDS = [:r, :f, :s, :h, :e]
    private_constant :SAVE_FOLDER, :SAVE_EXT, :DIFFICULTY_LEVELS,
                     :VALID_YESNO, :COMMANDS

    def initialize(save_to_load)
      if save_to_load.nil?
        @board = Board.new(*get_difficulty)
      else
        sanitized_name = sanitize_file_name!(save_to_load)
        load_path = "#{SAVE_FOLDER}#{sanitized_name}#{SAVE_EXT}"
        @board = load_save_game(load_path)
      end

      @last_frame_time = current_time
      @current_frame_time = current_time - @last_frame_time
    end

    def run
      game_over = false

      until game_over
        delta_time = update_frame_times

        player_action = get_player_action
        action_result = perform_action(*player_action)

        @board.render

        if action_result == Tile::MINE
          game_over = true
          puts "Game over!"
          break
        elsif @board.all_mines_found?
          game_over = true
          puts "You win!"
          break
        end
      end
    end

    private

    def get_difficulty
      difficulty = ""

      until DIFFICULTY_LEVELS.has_key?(difficulty)
        puts "Choose a difficulty level:"
        puts "(b)eginner, (i)ntermediate, or (e)xpert"
        print "> "
        difficulty = gets.chomp.downcase
      end

      DIFFICULTY_LEVELS[difficulty]
    end

    def update_frame_times
      @last_frame_time = @current_frame_time
      @current_frame_time = current_time
      @current_frame_time - @last_frame_time
    end

    def current_time
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end

    def perform_action(command, position)
      case command
      when "reveal"
        @board.reveal(position)
      when "flag"
        @board.toggle_flag(position)
      when "save"
        @board.render

        save_name = get_save_name
        return if save_name.empty?

        if confirm_save?(save_name)
          save_game(@board, "#{SAVE_FOLDER}#{save_name}#{SAVE_EXT}")
        end
      when "exit"
        @board.render

        if confirm_exit?
          system "clear"
          exit 0
        end
      else
        show_help
      end
    end

    def get_save_name
      puts "Enter a name for the save"
      puts "or press ENTER to return"
      print "> "
      sanitize_file_name!(gets.chomp)
    end

    def confirm_save?(save_name)
      return true unless File.exist?("saved_games/#{save_name}.sav")

      confirmation = ""
      until VALID_YESNO.include?(confirmation)
        puts "File already exists"
        puts "Would you like to overwrite, yes or no?"
        print "> "
        confirmation = gets.chomp.downcase
      end

      confirmation == "yes" || confirmation == "y"
    end

    def confirm_exit?
      confirmation = ""
      until VALID_YESNO.include?(confirmation)
        puts "All unsaved progress will be lost"
        puts "Are you sure you would like to exit, yes or no?"
        print "> "
        confirmation = gets.chomp.downcase
      end

      confirmation == "yes" || confirmation == "y"
    end

    def show_help
      system "clear"
      print "You must reveal all the safe tiles, but watch out because\n"\
            "revealing a mine means game over!\n\nAvailable commands:\n\n\t"\
            "Reveal - reveal a tile.\n\t\tThe number on the tile indicates the"\
            " number of\n\t\tadjacent tiles that contain mines.\n\tFlag - flag"\
            "/unflag a suspected mine.\n\t\tFlagged tiles cannot be revealed "\
            "until they are\n\t\tunflagged so you won't accidentally reveal "\
            "them.\n\tSave - save your game for later loading.\n\t\tTo load a "\
            "save game use the -l argument, followed\n\t\tby the name of the "\
            "game to load, when launching the game.\n\tExit - exits the game\n"\
            "\nYou may enter commands using just their first letter too.\n\n"\
            "Each command must be followed by row and column numbers separated"\
            "\nby a comma. Examples:\n\n\treveal 14,2\n\tf 2,0\n\nPress ENTER "\
            "to return..."
      gets
    end

    def get_player_action
      action = ""

      until valid_input?(action)
        puts "Enter an action (or \"help\" for instructions)"
        print "> "
        action = gets.chomp.downcase
      end

      parse_action(action)
    end

    def valid_input?(input)
      command, position = input.split(" ")
      return true if POSITIONLESS_COMMANDS.include?(command)
      return false if position.nil?

      position = position.split(",")
      return false unless position.length == 2

      row, col = position
      return false unless row.match?(/^\d+$/) && col.match?(/^\d+$/)

      POSITION_COMMANDS.include?(command) &&
        @board.valid_position?(position.map(&:to_i))
    end

    def parse_action(action)
      temp_command, temp_position = action.split(" ")

      case temp_command
      when "reveal", "r"
        command = "reveal"
      when "flag", "f"
        command = "flag"
      when "save", "s"
        command = "save"
        return [command, nil]
      when "exit", "e"
        command = "exit"
        return [command, nil]
      else
        command = "help"
        return [command, nil]
      end
      position = temp_position.split(",").map(&:to_i)

      [command, position]
    end
  end
end
