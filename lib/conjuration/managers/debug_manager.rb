require_relative "base_manager"

class DebugManager < BaseManager
  def render
    game.outputs.labels << [game.grid.w - 5, game.grid.h - 5, game.gtk.current_framerate, 0, 2]
  end
end
