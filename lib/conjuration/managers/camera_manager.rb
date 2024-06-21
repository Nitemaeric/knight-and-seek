class CameraManager
  CAMERA_LAYOUTS = {
    1 => [
      [0]
    ],
    2 => [
      [0, 1]
    ],
    3 => [
      [0, 1, 2],
    ],
    4 => [
      [0, 1],
      [2, 3]
    ],
  }

  attr_reader :scene, :cameras
  attr_accessor :panning

  def initialize(scene, camera_count: 1)
    @scene = scene
    @cameras = camera_count.times.map do
      Camera.new(scene, x: scene.grid.w / 2, y: scene.grid.h / 2)
    end
  end

  def add_camera(x:, y:)
    cameras << Camera.new(scene, x: x, y: y)
    calculate_camera_dimensions
  end

  def setup
    calculate_camera_dimensions
  end

  def render
    cameras.each_with_index do |camera, index|
      camera.render

      scene.game.outputs.borders << {
        x: camera.screen_x,
        y: camera.screen_y,
        w: camera.screen_w,
        h: camera.screen_h,
      }

      # scene.game.outputs.labels << {
      #   x: camera.screen_x + camera.screen_w / 2,
      #   y: camera.screen_y + camera.screen_h / 2,
      #   text: index + 1,
      #   alignment_enum: 1,
      #   vertical_alignment_enum: 1,
      #   size_enum: 10,
      # }

      # next unless camera.screen_x && camera.screen_y && camera.screen_w && camera.screen_h

      # if scene.inputs.mouse.inside_rect?(x: camera.screen_x, y: camera.screen_y, w: camera.screen_w, h: camera.screen_h)
      #   # source_x = x - (screen_w / 2) * zoom
      #   # scene_x = (camera.x + (scene.inputs.mouse.x - camera.screen_x)) / camera.zoom - camera.screen_w / 2
      #   scene_x = scene.inputs.mouse.x - camera.x
      #   scene_y = camera.screen_w + (scene.inputs.mouse.y - camera.y)

      #   scene.game.outputs.labels << {
      #     x: scene.inputs.mouse.x,
      #     y: scene.inputs.mouse.y,
      #     text: "(#{scene_x.to_sf}) x #{camera.zoom} > #{panning}",
      #   }
      # end
    end
  end

  def input
    self.panning = nil

    cameras.each_with_index do |camera, index|
      next unless camera.screen_x && camera.screen_y && camera.screen_w && camera.screen_h

      if scene.inputs.mouse.inside_rect?(x: camera.screen_x, y: camera.screen_y, w: camera.screen_w, h: camera.screen_h)
        if scene.inputs.mouse.wheel
          # camera.x, camera.y = scene.inputs.mouse.x, scene.inputs.mouse.y
          camera.zoom = (camera.zoom + scene.inputs.mouse.wheel.y * 0.1).round(2).greater(0.1)
        end

        if scene.inputs.mouse.button_left
          self.panning = index
        end
      end
    end
  end

  def update
    if panning
      camera = cameras[panning]
      camera.x = (camera.x - scene.inputs.mouse.relative_x / camera.zoom).round(2).greater(camera.screen_w / 2 / camera.zoom).lesser(scene.outputs.w - camera.screen_w / 2 / camera.zoom)
      camera.y = (camera.y - scene.inputs.mouse.relative_y / camera.zoom).round(2).greater(camera.screen_h / 2 / camera.zoom).lesser(scene.grid.h)
    end
  end

  private

  def calculate_camera_dimensions
    rows = CAMERA_LAYOUTS.fetch(cameras.length)

    rows.each_with_index do |columns, row_index|
      columns.each_with_index do |index, column_index|
        next if index.nil?

        screen_w = scene.grid.w / columns.length
        screen_h = scene.grid.h / rows.length

        cameras[index].merge!(screen_x: screen_w * column_index, screen_y: screen_h * (rows.length - 1 - row_index), screen_w: screen_w, screen_h: screen_h)
      end
    end
  end
end
