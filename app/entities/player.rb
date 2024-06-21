class Player
  attr_sprite

  attr_reader :color
  attr_accessor :action

  def initialize(x:, y:, color:)
    @x = x
    @y = y
    @color = color
    @w = 128
    @h = 128
    @tile_w = tile_size
    @tile_h = tile_size
    @action = :idle
    @anchor_x = 0.5
    @anchor_y = 0.5
  end

  def move_left
    @x -= 2.5
    @flip_horizontally = true
    @action = :moving
  end

  def move_right
    @x += 2.5
    @flip_horizontally = false
    @action = :moving
  end

  def move_up
    @y += 2.5
    @action = :moving
  end

  def move_down
    @y -= 2.5
    @action = :moving
  end

  def attack
    @attacking_at = $game.tick_count
    @action = :attacking
  end

  def tile_size
    192
  end

  def tile_x
    tile_size * (($game.tick_count / 5).to_i % 6)
  end

  def tile_y
    case action
    when :idle then 0
    when :moving then 192
    when :attacking then 384
    end
  end

  def path
    "sprites/player/#{color}.png"
  end

  def serialize
    { x: x, y: y, color: color }
  end
end
