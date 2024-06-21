class SceneManager < BaseManager
  attr_reader :current_scene

  def add_scene(key, scene_class)
    scenes[key] = scene_class
  end

  def set_scene(key, **options)
    @current_scene ||= scenes[key].new(game, key, **options)
  end

  def change_scene(key, **options)
    @options = options
    @current_scene = scenes[key].new(game, key, **options)
  end

  def setup
    return unless current_scene

    current_scene.perform_phase(:setup, @options)
    current_scene.camera_manager.setup
  end

  def render
    return unless current_scene

    current_scene.perform_phase(:render)
    current_scene.camera_manager.render
  end

  def input
    return unless current_scene

    current_scene.perform_phase(:input)
    current_scene.camera_manager.input
  end

  def update
    return unless current_scene

    current_scene.perform_phase(:update)
    current_scene.camera_manager.update
  end

  private

  def scenes
    @scenes ||= {}
  end
end
