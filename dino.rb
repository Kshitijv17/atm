

require 'gosu'

# Constants
WIDTH = 800
HEIGHT = 650
FPS = 60


# Game class
class Game < Gosu::Window
  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = 'T-Rex Game'
    @trex = Trex.new
    @horizon = Horizon.new
    @distance_meter = DistanceMeter.new
    @obstacles = []
    @game_over = false
    @score = 0
    @obstacle_timer = 0
  end

  def update
    if @game_over
      if Gosu.button_down?(Gosu::KB_SPACE)
        @game_over = false
        @trex.reset
        @horizon.reset
        @distance_meter.reset
        @obstacles.clear
        @score = 0
      end
    else
      @trex.update
      # Horizon doesn't need to update
      @distance_meter.update
      spawn_obstacles
      @obstacles.each(&:update)
      check_collisions
      @score += 1 if @distance_meter.update_score
    end
  end

  def draw
    @horizon.draw
    @trex.draw
    @distance_meter.draw
    @obstacles.each(&:draw)
    draw_score
    draw_game_over if @game_over
  end

  def draw_score
    font = Gosu::Font.new(24)
    font.draw_text("Score: #{@score}", 10, 10, 1)
  end

  def draw_game_over
    font = Gosu::Font.new(24)
    font.draw_text('Game Over', WIDTH / 2 - 50, HEIGHT / 2, 1)
    font.draw_text('Press SPACE to restart', WIDTH / 2 - 100, HEIGHT / 2 + 30, 1)
  end

  def button_down(id)
    if id == Gosu::KB_SPACE
      @trex.jump unless @game_over
    end
  end

  def spawn_obstacles
    @obstacle_timer += 1
    if @obstacle_timer > 60
      @obstacles << Obstacle.new
      @obstacle_timer = 0
    end
  end

  def check_collisions
    @obstacles.each do |obstacle|
      if @trex.collided_with?(obstacle)
        @game_over = true
      end
    end
  end
end

# Trex class
class Trex
  def initialize
    @x = 150
    @y = HEIGHT - 150
    @jumping = false
    @velocity = 0
    @img = Gosu::Image.new('./dino game/trex.png', retro: true)
  end

  def update
    if @jumping
      @velocity += 0.6
      @y += @velocity
      if @y > HEIGHT - 50
        @y = HEIGHT - 50
        @jumping = false
      end
    end
  end

  def jump
    if !@jumping
      @velocity = -30
      @jumping = true
    end
  end

  def draw
    @img.draw(@x, @y, 1)
  end

  def reset
    @x = 50
    @y = HEIGHT - 50
    @jumping = false
    @velocity = 0
  end

  def collided_with?(obstacle)
    @x < obstacle.x + obstacle.width && @x + 40 > obstacle.x && @y + 50 > obstacle.y
  end
end

# Horizon class
class Horizon
  def initialize
    @y = HEIGHT - 1000
    @img = Gosu::Image.new('./dino game/horizon.png', retro: true)
  end

  def draw
    @img.draw(0, @y, 1)
    @img.draw(WIDTH, @y, 1)
  end

  def reset
    # Reset horizon if necessary
  end
end

# DistanceMeter class
class DistanceMeter
  def initialize
    @x = WIDTH - 100
    @y = 5
    @distance = 0
  end

  def update
    @distance += 1
    @distance  # Return the distance to keep track of score
  end

  def draw
    font = Gosu::Font.new(24)
    font.draw_text(@distance.to_s, @x, @y, 1)
  end

  def reset
    @distance = 0
  end

  def update_score
    true
  end
end

# Obstacle class
class Obstacle
  attr_reader :x, :y, :width

  def initialize
    @x = WIDTH
    @y = HEIGHT - 30
    @width = 20
    @height = 30
    @speed = 6
    @img = Gosu::Image.new('./dino game/obstacle.png', retro: true)
  end

  def update
    @x -= @speed
  end

  def draw
    @img.draw(@x, @y, 1)
  end

  def width
    @width
  end

  def collided_with?(trex)
    trex.collided_with?(self)
  end
end

# Run the game
Game.new.show
