require "app/entities/knight"

class MainScene < Scene
  PLAYER_COLORS = %w[blue red yellow purple]

  def setup
    state.rows = 24
    state.columns = 24
    state.tile_size = 64

    state.tiles ||= Array.new(state.rows) { Array.new(state.columns) }

    state.rows.times do |row|
      state.columns.times do |column|
        state.tiles[row][column] = {
          tile_x: [64, 384].sample
        }
      end
    end

    self.width = state.columns * state.tile_size
    self.height = state.rows * state.tile_size

    state.players ||= config[:players].map_with_index do |player, index|
      {
        keymap: player[:keymap],
        character: Knight.new(x: width / 2 * index + width / 4, y: height / 2, color: PLAYER_COLORS[index])
      }
    end

    state.players.each_with_index do |player, index|
      if camera_manager.cameras[index].nil?
        camera_manager.add_camera(x: player.as_hash[:character].x, y: player.as_hash[:character].y)
      end
    end
  end

  def input
    input_manager.keymaps.each do |name, keymap|
      player = state.players.find { |player| player[:keymap] == keymap }

      next if player.nil?

      player.character.move_vector(keymap.directional_vector)
    end
  end

  def render
    outputs.primitives << state.tiles.map_2d do |row, column, tile|
      {
        x: column * state.tile_size,
        y: row * state.tile_size,
        w: state.tile_size,
        h: state.tile_size,
        tile_y: 64,
        tile_w: state.tile_size,
        tile_h: state.tile_size,
        path: "sprites/ground.png",
        primitive_marker: :sprite
      }.merge(tile)
    end

    outputs.primitives << state.players.map do |player|
      player.character
    end
  end

  def update
    state.players.each_with_index do |player, index|
      camera_manager.cameras[index].look_at(player.character)
    end
  end

  def debug
    state.players.map_with_index do |player, index|
      "player[#{index}]: [#{player.character.x}, #{player.character.y}]"
    end
  end
end
