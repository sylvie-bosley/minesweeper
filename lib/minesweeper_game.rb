require_relative "board"

module Minesweeper
  DIFFICULTY_LEVELS = ["beginner", "intermediate", "expert"]

  class MineGame
    def self.get_difficulty
      difficulty = ""

      until DIFFICULTY_LEVELS.include?(difficulty)
        puts "Choose a difficulty level:"
        puts "beginner, intermediate, or expert"
        difficulty = gets.chomp.downcase
      end

      difficulty
    end

    def initialize(difficulty)

    end
  end
end
