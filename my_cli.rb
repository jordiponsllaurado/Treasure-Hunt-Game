require "thor"

class MyCLI < Thor
  desc "hello NAME", "say hello to NAME"
  def hello(name)
    puts "Hello #{name}"
  end

  desc "play", "say hello to NAME"
  def play
    # TODO
  end

  desc "stop", "say hello to NAME"
  def stop
    # TODO
  end

  desc "check position X Y", "say if the treasure is there"
  def check_position(x, y)
    # TODO
  end
end

MyCLI.start(ARGV)