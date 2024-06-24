require_relative "managers/debug_manager"
require_relative "managers/scene_manager"

module Conjuration
  class Game < Node
    attr_gtk

    attr_accessor :debug_manager, :scene_manager

    def initialize(args)
      super(
        args: args,
        debug_manager: DebugManager.new,
        scene_manager: SceneManager.new
      )
    end

    def tick
      perform(:setup)  { setup }
      perform(:input)  { input }
      perform(:update) { update }
      perform(:render) { render }
    end

    private

    def perform(phase_name)
      yield

      [scene_manager, debug_manager].each do |manager|
        manager.perform(phase_name)
      end
    end
  end
end
