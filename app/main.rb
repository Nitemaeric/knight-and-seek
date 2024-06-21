require "lib/conjuration"

require "app/game"

def tick(args)
  $game ||= Game.new(args)
  $game.args = args
  $game.tick
end

def reset
  $game = nil
end
