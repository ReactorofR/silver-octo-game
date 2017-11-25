require 'gosu'

class Digger
  def initialize
    @image = Gosu::Image.new("../assets/digger.png")
    @x = Gosu.screen_width / 4 - @image.width * 2
    @y = 180
    @inverted = false
  end

  def draw
    if @inverted
      x = @x + @image.width
      iv = -1
    else
      x = @x
      iv = 1
    end

    @image.draw x - @image.width / 2,
                @y,
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
    @widht = 80
    sizeX = 16
    sizeY = 100
    @tiles = init_tiles(sizeX, sizeY)
  end

  def draw
    @tiles.each_index do |collumn,x|
      collumn.each_index do |tile,y|
        puts "Tile(#{x},#{y}): #{tile}"
      end
    end
    #Gosu.draw_rect()
  end

  private
  def init_tiles(sizeX,sizeY)
    tiles = Array.new(sizeX){Array.new(sizeY)}
    sizeX.times do |x|
      sizeY.times do |y|
        tiles[x][y] = {
          'status' => 'undug',
          # Types of block:
          # bedrock,rock,clay,dirt,ruby,sapphire,tin,copper,iron,gold,
          # aluminum,silver,platinum,diamond
          'type' => distribute_tiles(x,y)
        }
      end
    end
    puts tiles
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


class Game < Gosu::Window
  def initialize
    super 1280, 720
    self.caption = "Unobtainium"
    @player = Digger.new
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
  end

  def draw
    Gosu.draw_rect(0, 0, Gosu.screen_width, Gosu.screen_height, Gosu::Color.new(255,161,80,8))
    @player.draw
    @world.draw
  end
end

Game.new.show
