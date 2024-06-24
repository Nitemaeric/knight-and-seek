class MainMenuScene < Scene
  PLAYER_COLORS = %w[blue red yellow purple]

  def setup
    state.players ||= {}
  end

  def input
    inputs.controllers.each_with_index do |controller, index|
      if controller.key_down.a
        state.players[index] = state.new_entity :player, controller_index: index, ready: true
      end
    end

    state.players.each do |index, player|
      if inputs.controllers[player.controller_index].key_down.b
        state.players[index].ready = false
      end

      # if state.players.length > 1 && inputs.controllers[player.controller_index].key_down.start
      if inputs.controllers[player.controller_index].key_down.start
        scene_manager.register_scene(:main, MainScene)
        scene_manager.set_scene(:main, camera_count: 2, player_count: 2)
      end
    end
  end

  def render
    outputs.labels << { x: 640, y: 192.from_top, text: "Knight and Seek", size_enum: 20, alignment_enum: 1, font: "fonts/PatrickHand-Regular.ttf" }

    outputs.sprites << PLAYER_COLORS.map_with_index do |color, index|
      {
        x: column_center_x(index),
        y: 192,
        w: 192,
        h: 192,
        tile_x: 192 * (($game.tick_count / 5).to_i % 6),
        tile_y: 0,
        tile_w: 192,
        tile_h: 192,
        path: "sprites/player/#{color}.png",
        anchor_x: 0.5,
        anchor_y: 0.5,
        a: inputs.controllers[index].connected ? 255 : 192
      }
    end

    outputs.primitives << inputs.controllers.select(&:connected).map_with_index do |controller, index|
      [
        {
          x: column_center_x(index),
          y: 120 - (($game.tick_count + 90 * index) % 360 * 3).sin * 2,
          w: 300,
          h: 64,
          path: "sprites/banner_horizontal.png",
          anchor_x: 0.5,
          anchor_y: 0.5,
          primitive_marker: :sprite
        },
        {
          x: column_center_x(index),
          y: 120 - (($game.tick_count + 90 * index) % 360 * 3).sin * 2,
          text: state.players[index] && state.players[index][:ready] ? "READY" : "Press A to join",
          size_enum: 4,
          alignment_enum: 1,
          vertical_alignment_enum: 1,
          font: "fonts/PatrickHand-Regular.ttf",
          primitive_marker: :label
        }
      ]
    end

    if state.players.values.select { _1[:ready] }.length > 1
      outputs.labels << {
        x: 640,
        y: 60 - (($game.tick_count + 180) % 360 * 3).sin * 2,
        text: "Press START to begin",
        size_enum: 5,
        alignment_enum: 1,
        font: "fonts/PatrickHand-Regular.ttf"
      }
    end
  end

  private

  def column_center_x(index)
    width / 4 * (index + 1) - width / 8
  end
end
