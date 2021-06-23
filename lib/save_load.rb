# Module for saving and loading game state
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

require "yaml"
require "zaru"

module SaveLoad
  def self.load_save_game(load_path)
    YAML.load(File.read(load_path))
  rescue Errno::ENOENT
    puts "Requested save game does not exist!"
    print "Press ENTER to exit..."
    gets
    exit 1
  rescue IOError, SystemCallError
    puts "An unknown error occurred while trying to load the game."
    print "Press ENTER to exit..."
    gets
    exit 1
  end

  def self.save_game(save_object, save_path)
    File.open(save_path, "w") do |save_file|
      YAML.dump(save_object, save_file)
    end
  rescue IOError, SystemCallError
    puts "An unknown error occurred while trying to save the game."
    puts "Game was not saved!"
    print "Press ENTER to return..."
    gets
  end

  def self.sanitize_file_name!(file_name)
    Zaru.sanitize!(file_name, fallback: "")
  end
end
