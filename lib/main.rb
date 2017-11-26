require 'gosu'

class Digger
  attr_accessor :x,:y
  def initialize
    @image = Gosu::Image.new("../assets/digger.png")
    @x = Gosu.screen_width / 4 - @image.width * 2
    @y = -80
    @inverted = false
  end

  def draw(camera)
    if @inverted
      x = @x + @image.width
      iv = -1
    else
      x = @x
      iv = 1
    end

    @image.draw x - @image.width / 2,
                @y - camera.y,
                1,
                iv
  end

  def move_left
    @inverted = false
    @x -= 2
  end

  def move_right
    @inverted = true
    @x += 2
  end

  def move_down
    @y += 2
  end

  def move_up
    @y -= 2
  end
end

class Grid
  def initialize
    @height = 80
    @width = 80
    sizeX = 16
    sizeY = 100
    @tiles = init_tiles(sizeX, sizeY)
  end

  def setOccupied(x,y,state)
    @tiles[x][y]['occupied'] = state
  end

  def draw(camera)
    tile_colors = {
          'dirt' => Gosu::Color.argb(255,102,51,0),
          'rock' => Gosu::Color.argb(255,153,153,153),
          'ruby' => Gosu::Color.argb(255,155,17,30),
          'diamond' => Gosu::Color.argb(255,185,242,255),
          'sapphire' => Gosu::Color.argb(255,15,82,186)
        }
    @tiles.each_with_index do |column,x|
      column.each_with_index do |tile,y|
        Gosu.draw_rect(x * @width + camera.x, y * @height - camera.y ,@width,@height,tile_colors[tile['type']])
        Gosu.draw_rect(x * @width + camera.x, y * @height - camera.y ,@width,@height,Gosu::Color::YELLOW) if tile['occupied']
      end
    end
  end

  def update
    @tiles.flatten.each do |tile|
      if tile['occupied']
        tile['occupied'] = false
      end
    end
  end

  private
  def init_tiles(sizeX,sizeY)
    tiles = Array.new(sizeX){Array.new(sizeY)}
    sizeX.times do |x|
      sizeY.times do |y|
        tiles[x][y] = {
          'status' => 'undug',
          'occupied' => false,
          # Types of block:
          # bedrock,rock,clay,dirt,ruby,sapphire,tin,copper,iron,gold,
          # aluminum,silver,platinum,diamond
          'type' => distribute_tiles(x,y)
        }
      end
    end
    tiles
  end

  def distribute_tiles(x,y)
    random = Random::rand(100)
    return 'dirt' if random <= 79
    return 'rock' if random > 79 && random < 95
    return ['ruby','sapphire'].sample if random >= 95 && random < 100
    return 'diamond' if random == 100
  end
end

class Camera
  attr_accessor :x, :y

  def initialize
    @x = 0
    @y = 0
  end
end


class Game < Gosu::Window
  def initialize
    super 1280, 720
    self.caption = "Unobtainium"
    @player = Digger.new
    @camera = Camera.new
    @world = Grid.new
  end

  def update
    if Gosu.button_down? Gosu::KB_LEFT
      @player.move_left
    end
    if Gosu.button_down? Gosu::KB_RIGHT
      @player.move_right
    end
    if Gosu.button_down? Gosu::KB_DOWN
      @player.move_down
    end
    if Gosu.button_down? Gosu::KB_UP
      @player.move_up
    end

    #Update camera y
    @world.update
    @camera.y = @player.y - height / 2
    # Check what grid position the player is in
    x = (@player.x + 20) / 80
    y = (@player.y + 40) / 80
    @world.setOccupied(x,y,true)
  end

  def draw
    Gosu.draw_rect(0, 0, Gosu.screen_width, Gosu.screen_height, Gosu::Color::BLUE)
    @player.draw(@camera)
    @world.draw(@camera)
  end
end

Game.new.show
