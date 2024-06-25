require "app/keymap"

class MainMenuScene < Scene
  PLAYER_COLORS = %w[blue red yellow purple]

  def setup
    state.players ||= []
  end

  def input
    input_manager.keymaps.each do |name, keymap|
      player = state.players.find { |player| player[:keymap] == keymap }

      if keymap.key_down(:select) && player.nil?
        add_player(keymap)
      end

      if keymap.key_down(:back) && player
        remove_player(keymap)
      end

      if keymap.key_down(:start) && state.players.length > 1
        scene_manager.register_scene(:main, MainScene)
        scene_manager.set_scene(:main, camera_count: state.players.length, players: state.players)
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
        a: state.players[index] ? 255 : 192
      }
    end

    outputs.primitives << input_manager.keymaps.values.map_with_index do |controller, index|
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
          text: state.players[index] ? "READY" : "Press A to join",
          size_enum: 4,
          alignment_enum: 1,
          vertical_alignment_enum: 1,
          font: "fonts/PatrickHand-Regular.ttf",
          primitive_marker: :label
        }
      ]
    end

    if state.players.length > 1
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

  def add_player(keymap)
    state.players.push({ keymap: keymap })
  end

  def remove_player(keymap)
    state.players.find_index { _1[:keymap] == keymap }.then do |index|
      state.players.delete_at(index)
    end
  end

  def column_center_x(index)
    width / 4 * (index + 1) - width / 8
  end
end
