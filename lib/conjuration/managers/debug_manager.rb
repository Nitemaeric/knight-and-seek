class DebugManager < Node
  delegate :state, :inputs, :outputs, :gtk, to: :game

  def setup
    state.debug ||= false
  end

  def input
    return if gtk.production?

    state.debug = !state.debug if inputs.keyboard.key_down.f1
  end

  def render
    return unless state.debug

    outputs.labels << { x: game.grid.w - 5, y: game.grid.h - 5, text: gtk.current_framerate, size_enum: 0, alignment_enum: 2, r: 255, g: 255, b: 255 }

    debug_strings ||= []

    debug_strings << "current_scene: #{$game.scene_manager.current_scene} [#{$game.scene_manager.current_scene.width},#{$game.scene_manager.current_scene.height}]"

    $game.scene_manager.current_scene.camera_manager.cameras.each_with_index do |camera, index|
      rect = "[#{camera.x.to_i},#{camera.y.to_i},#{camera.w.to_i},#{camera.h.to_i}]"
      focus = "(#{camera.focus_x.to_i},#{camera.focus_y.to_i}@#{camera.zoom.to_sf})"
      debug_strings << "camera[#{index}]: #{rect} #{focus}"
    end

    $game.scene_manager.current_scene.debug.each do |debug|
      debug_strings << debug
    end

    outputs.primitives << { x: 0.from_right, y: 0.from_top, w: debug_strings.max_by(&:length).length * 9, h: 30 + debug_strings.length * 20, primitive_marker: :solid, anchor_x: 1, anchor_y: 1, r: 0, g: 0, b: 0, a: 128 }

    outputs.debug << debug_strings.map_with_index do |text, index|
      { text: text, x: game.grid.w - 5, y: game.grid.h - 25 - 20 * index, size_enum: -2, alignment_enum: 2, primitive_marker: :label, r: 255, g: 255, b: 255 }
    end

    outputs.debug << gtk.framerate_diagnostics_primitives
  end

  private

  def game
    $game
  end
end
