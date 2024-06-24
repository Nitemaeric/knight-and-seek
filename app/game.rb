require_relative "scenes/main_menu_scene"
require_relative "scenes/main_scene"
require_relative "scenes/map_editor_scene"

class Game < Conjuration::Game
  def setup
    scene_manager.register_scene(:main_menu, MainMenuScene)
    scene_manager.initial_scene(:main_menu)
  end

  def input
    # if inputs.keyboard.key_down.escape
  end
end
