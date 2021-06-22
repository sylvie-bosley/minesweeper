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
    COMMANDS = [:r, :f, :s, :h, :x]
    MOVEMENT_KEYS = [:up, :down, :left, :right]
    private_constant :SAVE_FOLDER, :SAVE_EXT, :DIFFICULTY_LEVELS,
                     :VALID_YESNO, :COMMANDS, :MOVEMENT_KEYS

    def initialize(save_to_load)
      if save_to_load.nil?
        @board = Board.new(*get_difficulty)
      else
        sanitized_name = sanitize_file_name!(save_to_load)
        load_path = "#{SAVE_FOLDER}#{sanitized_name}#{SAVE_EXT}"
        @board = load_save_game(load_path)
      end
    end

    def run
      @board.render
      Remedy::Interaction.new.loop do |player_action|
        if MOVEMENT_KEYS.include?(player_action.name)
          @board.move_cursor(player_action.name)
        end

        if COMMANDS.include?(player_action.name)
          action_result = perform_action(player_action.name)
        else
          action_result = nil
        end

        @board.render

        if action_result == Tile::MINE
          puts "Game over!"
          break
        elsif @board.all_mines_found?
          puts "You win!"
          break
        end
      end

      print "Press ENTER to exit..."
      gets
      system "clear"
      exit 0
    rescue Remedy::Keyboard::ControlC
      Remedy::ANSI.cursor.show!
      save_and_exit?
      system "clear"
      exit 0
    ensure
      Remedy::ANSI.cursor.show!
    end

    private

    def save_and_exit?
      confirmation = ""

      until VALID_YESNO.include?(confirmation)
        puts "Exiting..."
        puts "Would you like to save first, yes or no?"
        print "> "
        confirmation = gets.chomp
      end

      if confirmation == "yes" || confirmation == "y"
        perform_action(:s)
        return true
      else
        return false
      end
    end

    def get_difficulty
      choices = DIFFICULTY_LEVELS.keys
      cursor = choices.first
      key = Remedy::Key.new("V")
      until key.name == :control_m
        system "clear"

        puts "Choose a difficulty level:"

        print "> " if cursor == :beginner
        puts "beginner"
        print "> " if cursor == :intermediate
        puts "intermediate"
        print "> " if cursor == :expert
        puts "expert"

        next unless key = Remedy::Interaction.new.get_key

        if key.name == :down
          choices.rotate!
          cursor = choices.first
        elsif key.name == :up
          choices.rotate!(-1)
          cursor = choices.first
        end
      end

      DIFFICULTY_LEVELS[cursor]
    end

    def perform_action(command)
      case command
      when :r
        @board.reveal
      when :f
        @board.toggle_flag
      when :s
        save_name = get_save_name
        return if save_name.empty?

        if confirm_save?(save_name)
          save_game(@board, "#{SAVE_FOLDER}#{save_name}#{SAVE_EXT}")
        end
      when :x
        if save_and_exit? || confirm_exit?
          system "clear"
          exit 0
        end
      else
        show_help
      end
    end

    def get_save_name
      puts "Enter a name for the save"
      puts "Enter a blank name to cancel"
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
  end
end
