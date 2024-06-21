require_relative "managers/camera_manager"

class Scene
  include Delegates

  attr_reader :game, :name, :camera_manager
  attr_accessor :width, :height

  delegate :inputs, :state, :grid, to: :game

  def initialize(game, name, camera_count: 1, **options)
    @game = game
    @options = options
    @camera_manager = CameraManager.new(self, camera_count: camera_count)

    outputs.transient!
  end

  def perform_phase(phase_name, options = {})
    case phase_name
    when :setup
      setup(options)
    when :render
      render
    when :input
      input
    when :update
      update
    end
  end

  def outputs
    game.outputs[:scene]
  end

  # =====
  # Abstract methods
  # =====

  # Setup your data structures here.
  #
  # Read/Write state.
  #
  # @methods state
  def setup; end

  # Render your data structures here
  #
  # Read state only.
  #
  # @methods outputs
  def render; end

  # Handle user input here
  #
  # Read/Write state.
  #
  # @methods inputs
  # @methods state
  def input; end

  # Ongoing game loop logic goes here
  #
  # Read/Write state.
  #
  # @methods state
  def update; end

  def self.state_attribute(attribute_name, default: nil)
    define_method(attribute_name) do
      game.state.as_hash[name].as_hash[attribute_name] || default
    end

    define_method("#{attribute_name}=") do |value|
      game.state[name][attribute_name] = value
    end
  end
end
