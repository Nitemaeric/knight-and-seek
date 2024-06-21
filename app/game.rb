require_relative "scenes/main_menu_scene"
require_relative "scenes/main_scene"

class Game < Conjuration::Game
  def setup
    scene_manager.add_scene(:main_menu, MainMenuScene)
    scene_manager.set_scene(:main_menu)
  end

  def input
    if inputs.keyboard.key_up.one
      puts "Switching to main menu scene"
      scene_manager.change_scene(:main_menu)
    elsif inputs.keyboard.key_up.two
      puts "Switching to main scene"
      scene_manager.change_scene(:main)
    end
  end

  # def render
  #   outputs.labels << [inputs.mouse.x, inputs.mouse.y + 20, "(#{inputs.mouse.x}, #{inputs.mouse.y})", 255, 255, 255]

  #   4.times do |i|
  #     outputs.lines << [grid.w / 4 * i, 0, grid.w / 4 * i, grid.h, 255, 255, 255]
  #   end
  # end
end
