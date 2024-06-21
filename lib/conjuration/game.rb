require_relative "managers/debug_manager"
require_relative "managers/scene_manager"

module Conjuration
  class Game
    attr_gtk

    attr_reader :debug_manager, :scene_manager, :players

    def initialize(args)
      self.args = args

      @players = []
      @debug_manager = DebugManager.new(self)
      @scene_manager = SceneManager.new(self)
    end

    def tick
      perform_phase(:setup)  { setup }
      perform_phase(:render) { render }
      perform_phase(:input)  { input }
      perform_phase(:update) { update }
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

    private

    def perform_phase(phase_name)
      [debug_manager, scene_manager].each { |manager| manager.send(phase_name) }

      yield
    end
  end
end
