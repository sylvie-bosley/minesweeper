require "yaml"
require "zaru"

module SaveLoad
  def load_save_game(load_path)
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

  def save_game(save_object, save_path)
    File.open(save_path, "w") do |save_file|
      YAML.dump(save_object, save_file)
    end
  rescue IOError, SystemCallError
    puts "An unknown error occurred while trying to save the game."
    puts "Game was not saved!"
    print "Press ENTER to return..."
    gets
  end

  def sanitize_file_name!(file_name)
    Zaru.sanitize!(file_name, fallback: "")
  end
end
