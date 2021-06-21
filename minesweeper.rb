# Launches and initialization of the game
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

require_relative "lib/minesweeper_game"

include Minesweeper

save_name = ARGV.shift.strip if ARGV.shift == "-l"
ARGV.clear

system("clear")
puts "Pierce's Minesweeper  Copyright (C) 2021  Thomas Pierce Bosley\n"\
     "This program comes with ABSOLUTELY NO WARRANTY; for details type "\
     "`warranty'.\nThis is free software, and you are welcome to redistribute "\
     "it under\ncertain conditions; see the source code for copying conditions."
print "> "
copyright_input = gets.chomp

if copyright_input == "warranty"
  system("clear")
  puts "15. Disclaimer of Warranty.\n\n"\
       "  THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY\n"\
       "APPLICABLE LAW.  EXCEPT WHEN OTHERWISE STATED IN WRITING THE "\
       "COPYRIGHT\nHOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM \"AS IS\""\
       " WITHOUT WARRANTY\nOF ANY KIND, EITHER EXPRESSED OR IMPLIED, "\
       "INCLUDING, BUT NOT LIMITED TO,\nTHE IMPLIED WARRANTIES OF "\
       "MERCHANTABILITY AND FITNESS FOR A PARTICULAR\nPURPOSE.  THE ENTIRE "\
       "RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM\nIS WITH YOU. "\
       " SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF\nALL "\
       "NECESSARY SERVICING, REPAIR OR CORRECTION.\n\n"\
       "You should have received a copy of the GNU General Public License "\
       "along\nwith this program. If you did not, the terms can be found "\
       "at:\n\n    https://www.gnu.org/licenses/licenses.en.html"
  puts
  print "> "
  gets
end
system("clear")

if save_name.nil?
  save_file = nil
  difficulty = MineGame.get_difficulty
else
  sanitized_name = Zaru.sanitize!(save_name, fallback: "")
  save_file = "#{MineGame::SAVE_FOLDER}#{sanitized_name}#{MineGame::SAVE_EXT}"
  difficulty = nil
end

game = MineGame.new(difficulty, save_file)
game.run
