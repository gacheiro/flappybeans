require 'gosu'
require_relative 'config'
require_relative 'gameobjs'

module Flappy
  class Game < Gosu::Window
    def initialize(width, height, caption)
      super width, height
      self.caption = caption
      @score = 0
      @game_over = false

      @background_image = Flappy::IMAGES[:background]
      # Game objects
      @player = create_player
      @obstacles = []
      @floor = []
    end

    def game_objects
      [@player] + @obstacles + @floor
    end

    def update
      game_objects.each(&:update)

      # Create random obstacles
      if @obstacles.size < 20
        @obstacles += create_obstacle
      end
      # Create floor (only need 2 to fill the screen horizontally)
      if @floor.count < 2
        @floor << create_floor
      end

      # Check collision beetween player and obstacles and floor
      (@obstacles + @floor).each do |obj|
        if obj.collide?(@player)
          case obj.on_collide
          when :kill
            game_over
          when :score
            @score += obj.score!
            puts @score
          end
        end
      end

      # Clean up old gameobjs
      cleanup_gameobjects
    end

    def draw
      @background_image.draw(0, 0, Flappy::Z[:background])
      game_objects.each(&:draw)
      draw_score
      debug_bodies if Flappy::DEBUG
    end

    def button_down(id)
      if id == Gosu::KB_UP
        @player.flap unless @game_over
      else
        super
      end
    end

    private

      def draw_score
        # Draw the player's score using digit images
        digits = Flappy::IMAGES[:digits]
        dwidth = 15
        # Center the score at width/2
        size = @score.to_s.size
        x = self.width/2 - size*dwidth/2
        # Draw each digit individually
        @score.to_s.each_char do |d|
          digits[d.to_i].draw(x, 30, Flappy::Z[:ui])
          x += dwidth
        end
      end

      def debug_bodies
        game_objects.each do |obj|
          x, y, width, height = obj.rect
          z = Flappy::Z[:debug]
          Gosu::draw_rect(x, y, width, height, Gosu::Color::GREEN, z)
        end
      end

      def game_over
        @game_over = true
        @player.allow_gravity = false
        @player.vel_x = @player.vel_y = 0
      end

      def create_player
        x = self.width/2
        y = self.height/2
        z = Flappy::Z[:player] 
        frames = Flappy::IMAGES[:player]
        Flappy::FlappyBean.new(x, y, z, frames)
      end

      def create_obstacle
        offset_x =
          if @obstacles.empty?
            # Create first obstacle at the right border
            self.width
          else
            # Take care not to create and obstacle on top of another
            @obstacles.last.x
          end

        # Place the obstacle at a random position
        x = offset_x + rand(200..250)
        y = rand(-225..0)
        z = Flappy::Z[:obstacle]
        # Spacing beetween top and bottom obstacles
        v_spacing = Flappy::OBSTACLE_VSPACING

        # Create random looking obstacles
        top = Flappy::IMAGES[:obstacle_top].sample
        bottom = Flappy::IMAGES[:obstacle_bottom].sample
        # Also create an (invisible) scorable obstacle
        # Which will increase player's score on collide
        scorable = Flappy::IMAGES[:score_obstacle]
        return [
          Flappy::Obstacle.new(x, y, z, top),
          Flappy::Scorable.new(x + top.width, y + top.height, scorable),
          Flappy::Obstacle.new(x, y + top.height + v_spacing, z, bottom),
        ]
      end

      def create_floor
        width = Flappy::IMAGES[:floor].width
        x =
          if @floor.empty?
            0
          else
            @floor.last.x + width - 1
          end
        y = self.height - 60
        z = Flappy::Z[:floor]
        Flappy::Floor.new(x, y, z, Flappy::IMAGES[:floor])
      end

      def cleanup_gameobjects
        @obstacles.reject!(&:destroy?)
        @floor.reject!(&:destroy?)
      end
  end
end
