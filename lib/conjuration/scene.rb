require_relative "managers/camera_manager"

class Scene < Node
  attr_accessor :key, :camera_manager, :config
  attr_reader :width, :height

  delegate :inputs, :grid, :layout, :scene_manager, :input_manager, to: :game

  def initialize(key, camera_count: 1, **config)
    super(
      key: key,
      config: config,
      width: grid.w,
      height: grid.h
    )

    self.camera_manager = CameraManager.new(scene: self, camera_count: camera_count)
  end

  def width=(value)
    @width = outputs.width = value
  end

  def height=(value)
    @height = outputs.height = value
  end

  def state
    $game.state[key.to_sym]
  end

  def outputs
    $game.outputs[:scene]
  end

  def debug
    []
  end

  private

  def perform_setup
    outputs.transient!
  end

  def perform_render?
    !setup_at.nil?
  end

  def game
    $game
  end
end
