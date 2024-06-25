require_relative "scenes/main_menu_scene"
require_relative "scenes/main_scene"
require_relative "scenes/map_editor_scene"

class Game < Conjuration::Game
  def setup
    scene_manager.register_scene(:main_menu, MainMenuScene)
    scene_manager.initial_scene(:main_menu)

    input_manager.register_keymap :left_keyboard, KeyboardKeymap.load_keymap(:left_keyboard)
    input_manager.register_keymap :right_keyboard, KeyboardKeymap.load_keymap(:right_keyboard)
    input_manager.register_keymap :controller_one, ControllerKeymap.load_keymap(:controller, name: :controller_one)
    input_manager.register_keymap :controller_two, ControllerKeymap.load_keymap(:controller, name: :controller_two)
    input_manager.register_keymap :controller_three, ControllerKeymap.load_keymap(:controller, name: :controller_three)
    input_manager.register_keymap :controller_four, ControllerKeymap.load_keymap(:controller, name: :controller_four)
  end

  def input
    # if inputs.keyboard.key_down.escape
  end
end
