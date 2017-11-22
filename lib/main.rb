require 'gosu'

class Digger
    def initialize
        @image = Gosu::Image.new("../assets/digger.png")
        @x = Gosu.screen_width / 4 - @image.width * 2
        @y = 200
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
        @size = {'x' => 16, 'y' => 100}
        @tiles = Array.new(@size['x']){Array.new(@size['y'])}
    end
     
    private
    def init_tiles
       @size['x'].each do |x|
         @size['y'].each do |y|

         end
       end
    end
end


class Game < Gosu::Window
    def initialize
        super 1280, 720
        self.caption = "Unobtainium"
        @player = Digger.new
        Grid.new
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
    end
end

Game.new.show