require_relative "board"

module Minesweeper
  DIFFICULTY_LEVELS = {
    "beginner" => [[9, 9], 10],
    "intermediate" => [[16, 16],	40],
    "expert" => [[16,	30],	99]
  }

  class MineGame
    def self.get_difficulty
      difficulty = ""

      until DIFFICULTY_LEVELS.has_key?(difficulty)
        puts "Choose a difficulty level:"
        puts "beginner, intermediate, or expert"
        difficulty = gets.chomp.downcase
      end

      DIFFICULTY_LEVELS[difficulty]
    end

    def initialize(difficulty)
      @board = Board.new(*difficulty)
    end

    private
  end
end
