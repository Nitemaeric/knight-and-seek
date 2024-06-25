class DebugManager < Node
  delegate :state, :inputs, :outputs, :grid, :gtk, to: :game

  attr_accessor :debug_strings

  def setup
    state.debug ||= false
  end

  def input
    return if gtk.production?

    state.debug = !state.debug if inputs.keyboard.key_down.f1
  end

  def render
    gtk.framerate_diagnostics_primitives.select { _1[:primitive_marker] == :label }.map(&:text).each do |text|
      debug_strings << text
    end

    debug_strings << "current_scene: #{current_scene.debug_inspect}"

    current_scene.camera_manager.cameras.each_with_index do |camera, index|
      rect = "[#{camera.x.to_i},#{camera.y.to_i},#{camera.w.to_i},#{camera.h.to_i}]"
      focus = "(#{camera.focus_x.to_i},#{camera.focus_y.to_i}@#{camera.zoom.to_sf})"
      debug_strings << "camera[#{index}]: #{rect} #{focus}"
    end

    current_scene.debug.each do |debug|
      debug_strings << debug
    end

    string_w, _ = gtk.calcstringbox debug_strings.max_by(&:length), -2, "font.ttf"

    outputs.primitives << { x: 0.from_right, y: 0, w: string_w + 20, h: grid.h, primitive_marker: :solid, r: 0, g: 0, b: 0, a: 128, anchor_x: 1 }

    outputs.debug << debug_strings.uniq.map_with_index do |text, index|
      { text: text, x: 10.from_right, y: (10 + 20 * index).from_top, size_enum: -2, alignment_enum: 2, primitive_marker: :label, r: 255, g: 255, b: 255 }
    end

    outputs[:scene_with_cameras].transient!
    outputs[:scene_with_cameras].width = current_scene.width
    outputs[:scene_with_cameras].height = outputs[:scene].height
    outputs[:scene_with_cameras].primitives << {
      x: 0,
      y: 0,
      w: current_scene.width,
      h: outputs[:scene].h,
      path: :scene,
    }
    outputs[:scene_with_cameras].primitives << current_scene.camera_manager.cameras.map_with_index do |camera, index|
      {
        x: camera.x,
        y: camera.y,
        w: camera.w,
        h: camera.h,
        primitive_marker: :border
      }
    end

    outputs.primitives << {
      x: 10,
      y: (10 + grid.h / 6).from_top,
      w: grid.w / 6,
      h: grid.h / 6,
      path: :scene_with_cameras,
      a: 196
    }
    outputs.borders << {
      x: 10,
      y: (10 + grid.h / 6).from_top,
      w: grid.w / 6,
      h: grid.h / 6,
      a: 196
    }
  end

  def update
    @debug_strings = []
  end

  private

  def perform_render?
    state.debug
  end

  def perform_update?
    state.debug
  end

  def game
    $game
  end

  def current_scene
    game.scene_manager.current_scene
  end
end
