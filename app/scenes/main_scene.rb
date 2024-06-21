require "app/entities/player"

class MainScene < Scene
  WORLD_WIDTH = 2000
  WORLD_HEIGHT = 2000

  def setup(first_user_input: nil, **options)
    state.players ||= {
      first_user_input => Player.new(x: grid.w / 4 * 2, y: grid.h / 4 * 2, color: "blue")
    }
    outputs.width = WORLD_WIDTH
    outputs.height = WORLD_HEIGHT
  end

  def render
    (0..WORLD_WIDTH).select { |x| x % 64 == 0 }.each do |x|
      (0..WORLD_HEIGHT).select { |y| y % 64 == 0 }.each do |y|
        outputs.primitives << { x: x, y: y, w: 64, h: 64, tile_x: 64, tile_y: 64, tile_w: 64, tile_h: 64, path: "sprites/ground.png", primitive_marker: :sprite }
        # outputs.primitives << { x: x, y: y, w: 64, h: 64, r: 0, g: 0, b: 0, a: 100, primitive_marker: :border }

        # text_x = (x + 64 / 2).to_i
        # text_y = (y + 64 / 2).to_i

        # outputs.primitives << { x: text_x, y: text_y, text: "#{text_x},#{text_y}", size_enum: -4, primitive_marker: :label, alignment_enum: 1, vertical_alignment_enum: 1 }
      end
    end

    state.players.each do |_, player|
      outputs.primitives << player
    end
  end

  def input
    inputs.controllers.each_with_index do |controller, index|
      if controller.key_up.start
        state.players[controller] = Player.new(x: grid.w / 4 * 3, y: grid.h / 4 * 2, color: ["red", "yellow", "purple"][index])
        camera_manager.add_camera(x: state.players[controller].x, y: state.players[controller].y)
      end
    end

    state.players.each do |input, player|
      player.action = :idle

      player.move_right if input.right
      player.move_left  if input.left
      player.move_up    if input.up
      player.move_down  if input.down

      # if input.respond_to?(:name)
      #   player.attack if input.a
      # else
      #   player.attack if input.space
      # end
    end
  end
end
