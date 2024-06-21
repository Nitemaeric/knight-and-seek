class MainMenuScene < Scene
  def setup(options = {})
    state.connected_controllers ||= []
  end

  def input
    first_user_input = inputs.keyboard       if inputs.keyboard.key_up.space
    first_user_input = inputs.controller_one if inputs.controller_one.key_up.start

    if first_user_input
      game.scene_manager.add_scene(:main, MainScene)
      game.scene_manager.change_scene(:main, first_user_input: first_user_input)
    end
  end

  def render
    outputs.labels << { x: 640, y: 192.from_top, text: "Knight and Seek", size_enum: 20, alignment_enum: 1, font: "fonts/PatrickHand-Regular.ttf" }

    state.connected_controllers.each_with_index do |control, index|
      outputs.sprites << {
        x: column_center_x(0),
        y: 120,
        w: 288,
        h: 64,
        path: "sprites/banner_horizontal.png",
        anchor_x: 0.5,
        anchor_y: 0.5
      }
      outputs.labels << {
        x: column_center_x(0),
        y: 120,
        text: "Press ENTER",
        size_enum: 4,
        alignment_enum: 1,
        vertical_alignment_enum: 1,
        font: "fonts/PatrickHand-Regular.ttf"
      }
    end

    %w[red blue yellow purple].each_with_index do |color, i|
      outputs.sprites << {
        x: column_center_x(i),
        y: 192,
        w: 192,
        h: 192,
        tile_x: 192 * (($game.tick_count / 5).to_i % 6),
        tile_y: 0,
        tile_w: 192,
        tile_h: 192,
        path: "sprites/player/#{color}.png",
        anchor_x: 0.5,
        anchor_y: 0.5
      }
    end

    if game.players.length > 1
      outputs.labels << { x: 640, y: 60, text: "Press SPACE to start", size_enum: 5, alignment_enum: 1, font: "fonts/PatrickHand-Regular.ttf" }
    end
  end

  private

  def column_center_x(index)
    grid.w / 4 * (index + 1) - grid.w / 8
  end
end
