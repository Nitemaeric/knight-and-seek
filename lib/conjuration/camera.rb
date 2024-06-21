class Camera
  attr_accessor :scene, :x, :y, :zoom, :target_x, :target_y, :target_zoom

  attr_accessor :screen_x, :screen_y, :screen_w, :screen_h

  def initialize(scene, x: nil, y: nil)
    @scene = scene
    @x = x || scene.grid.w / 2
    @y = y || scene.grid.h / 2
    @screen_w = scene.grid.w
    @screen_h = scene.grid.h
    @zoom = 1
  end

  def render
    outputs.primitives << {
      x: screen_x,
      y: screen_y,
      w: screen_w,
      h: screen_h,
      source_x: x - (screen_w / 2) / zoom,
      source_y: y - (screen_h / 2) / zoom,
      source_w: screen_w / zoom,
      source_h: screen_h / zoom,
      path: :scene
    }
  end

  def merge!(**attributes)
    attributes.each do |key, value|
      send("#{key}=", value)
    end
  end

  private

  def outputs
    scene.game.outputs
  end
end
