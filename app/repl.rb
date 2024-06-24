def current_scene
  $game.scene_manager.current_scene
end

def cameras
  current_scene.camera_manager.cameras
end
