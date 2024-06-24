require "app/entities/knight"

class MainScene < Scene
  PLAYER_COLORS = %w[blue red yellow purple]

  def setup
    state.rows = 24
    state.columns = 24
    state.tile_size = 64

    self.width = state.columns * state.tile_size
    self.height = state.rows * state.tile_size

    state.players ||= config[:player_count].times.each_with_object({}) do |index, hash|
      hash[index] = Knight.new(x: width / 2 * index + width / 4, y: height / 2, color: PLAYER_COLORS[index])

      if camera_manager.cameras[index].nil?
        camera_manager.add_camera(x: hash[index].x, y: hash[index].y)
      end
    end
  end

  def render
    outputs.primitives << (0..state.rows).flat_map do |row|
      (0..state.columns).map do |column|
        {
          x: column * state.tile_size,
          y: row * state.tile_size,
          w: state.tile_size,
          h: state.tile_size,
          tile_x: 64,
          tile_y: 64,
          tile_w: state.tile_size,
          tile_h: state.tile_size,
          path: "sprites/ground.png",
          primitive_marker: :sprite
        }
      end
    end

    outputs.primitives << state.players.map do |_, player|
      player
    end
  end

  def input
    state.players.each do |index, player|
      player.action = :idle

      player.move_right if inputs.controllers[index].right
      player.move_left  if inputs.controllers[index].left
      player.move_up    if inputs.controllers[index].up
      player.move_down  if inputs.controllers[index].down
    end

    if inputs.keyboard.key_up.escape
      scene_manager.change_scene(:main_menu)
    end
  end

  def update
    state.players.each do |index, player|
      camera_manager.cameras[index].look_at(player)
    end
  end

  def debug
    state.players.map do |index, player|
      "player[#{index}]: [#{player.x}, #{player.y}]"
    end
  end
end
