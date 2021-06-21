require_relative "lib/minesweeper_game"

include Minesweeper

difficulty = MineGame.get_difficulty

game = MineGame.new(difficulty)
game.run
