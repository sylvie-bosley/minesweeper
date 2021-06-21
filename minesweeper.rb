require_relative "lib/minesweeper_game"

difficulty = Minesweeper::MineGame.get_difficulty
game = Minesweeper::MineGame.new(difficulty)
game.run
