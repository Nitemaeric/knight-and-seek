class MapEditorScene < Scene
  def setup
    state.map_container = layout.rect(row: 0, col: 0, w: 18, h: 12)
    state.minimap_container = layout.rect(row: 0, col: 18, w: 6, h: 4)
    state.tiles_container = layout.rect(row: 5, col: 18, w: 6, h: 7)

    state.camera.x = state.map_container.w / 2
    state.camera.y = state.map_container.h / 2

    state.tiles = 48.times.map do |row|
      64.times.map do |col|
        { x: col * 64, y: row * 64, w: 64, h: 64 }
      end
    end

    # state.tile_selection = [
    #   [{ type: :grass, , type: :sand }]
    # ]

    state.selected = { tile: :grass, height: 1 }
  end

  def render
    # outputs.background_color = [255, 255, 255]

    # source_x = (state.camera.x - state.map_container.w / 2)
    # source_y = (state.camera.y - state.map_container.h / 2)

    # outputs.debug.watch "camera: #{state.camera.as_hash.slice(:x, :y, :zoom, :panning).to_s}"
    # outputs.debug.watch "mouse: #{{ x: inputs.mouse.x, y: inputs.mouse.y }}"
    # outputs.debug.watch "selected: #{state.selected.to_s}"

    # outputs[:map].transient!
    # outputs[:map].width = 64 * 64
    # outputs[:map].height = 48 * 64

    # state.tiles.each_with_index do |columns, row|
    #   columns.each_with_index do |tile, col|
    #     outputs[:map].borders << { x: tile.x, y: tile.y, w: tile.w, h: tile.h, r: 0, g: 0, b: 0, a: 128 }
    #     outputs[:map].labels << { x: tile.x + tile.w / 2, y: tile.y + tile.h / 2, text: "#{col},#{row}", size_enum: 0, alignment_enum: 1, vertical_alignment_enum: 1, r: 0, g: 0, b: 0, a: 128 }

    #     if tile[:type] == :grass
    #       outputs[:map].sprites << { x: tile.x, y: tile.y, w: tile.w, h: tile.h, tile_x: 64, tile_y: 64, tile_w: 64, tile_h: 64, path: "sprites/ground.png" }
    #     end

    #     if inputs.mouse.inside_rect?(state.map_container)
    #       if Geometry.inside_rect?({ x: inputs.mouse.x - state.map_container.x + state.camera.x - state.map_container.w / 2, y: inputs.mouse.y - state.map_container.y + state.camera.y - state.map_container.h / 2, w: 1, h: 1 }, { x: tile.x, y: tile.y, w: tile.w, h: tile.h })
    #         outputs[:map].solids << { x: tile.x, y: tile.y, w: tile.w, h: tile.h, r: 128, g: 128, b: 128, a: 128 }
    #       end
    #     end
    #   end
    # end

    # outputs[:tiles].transient!
    # outputs[:tiles].width = 64 * 5
    # outputs[:tiles].height = 64 * 5

    # if inputs.mouse.inside_rect?(state.tiles_container)
    #   # if Geometry.inside_rect?({ x: inputs.mouse.x - state.tiles_container.x + state.camera.x - state.tiles_container.w / 2, y: inputs.mouse.y - state.tiles_container.y + state.camera.y - state.tiles_container.h / 2, w: 1, h: 1 }, { x: tile.x, y: tile.y, w: tile.w, h: tile.h })
    # end
    # outputs[:tiles].sprites << { x: 0, y: 0, w: 64, h: 64, tile_x: 64, tile_y: 64, tile_w: 64, tile_h: 64, path: "sprites/ground.png" }

    # # outputs.primitives << layout.debug_primitives
    # outputs.primitives << state.map_container.merge(path: :map, source_x: source_x, source_y: source_y, source_w: state.map_container.w, source_h: state.map_container.h)
    # outputs.primitives << state.map_container.merge(path: :map, r: 0, g: 0, b: 0, primitive_marker: :border)
    # outputs.primitives << state.tiles_container.merge(path: :tiles, source_w: state.tiles_container.w, source_h: state.tiles_container.h)
    # outputs.primitives << state.tiles_container.merge(path: :tiles, r: 0, g: 0, b: 0, primitive_marker: :border)
    # outputs.primitives << state.minimap_container.merge(path: :map)
    # outputs.primitives << state.minimap_container.merge(path: :minimap, r: 0, g: 0, b: 0, primitive_marker: :border)
    #
    outputs.primitives << layout.debug_primitives
  end

  def input
    state.camera.panning = inputs.mouse.button_middle

    if inputs.mouse.inside_rect?(state.map_container) && inputs.mouse.button_left
      tile = state.tiles.flatten.find { |tile| Geometry.inside_rect?({ x: inputs.mouse.x - state.map_container.x + state.camera.x - state.map_container.w / 2, y: inputs.mouse.y - state.map_container.y + state.camera.y - state.map_container.h / 2, w: 1, h: 1 }, tile) }

      if inputs.mouse.button_left
        tile[:type] = state.selected.tile
      end

      if inputs.mouse.button_right
        tile[:type] = nil
      end
    end
  end

  def update
    if state.camera.panning
      state.camera.x = (state.camera.x - inputs.mouse.relative_x).greater(state.map_container.w / 2).lesser(outputs[:map].width - state.map_container.w / 2)
      state.camera.y = (state.camera.y - inputs.mouse.relative_y).greater(state.map_container.h / 2).lesser(outputs[:map].height - state.map_container.h / 2)
    end
  end
end
