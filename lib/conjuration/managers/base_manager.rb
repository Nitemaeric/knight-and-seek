class BaseManager
  include Attributes

  attr_reader :game

  def initialize(game)
    @game = game
  end

  # =====
  # Abstract methods
  # =====

  def setup; end
  def render; end
  def input; end
  def update; end
end
