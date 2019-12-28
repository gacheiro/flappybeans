require_relative 'ext/sprite'

module Flappy
  class FlappyBean < Sprite
    def initialize(x, y)
      @frames = Flappy::IMAGES[:player]
      super(image: @frames.first,
            x: x,
            y: y,
            z: Flappy::Z[:player],
            allow_gravity: true)
    end

    def flap
      @vel_y = -10
      @angle = -45
    end

    def falling?
      @vel_y > 0
    end

    def update
      super
      @image =
        if falling?
          @frames.last
        else
          @frames.first
        end
    end

    def draw
      # The draw_rot centers the image at (x, y)
      @image.draw_rot(@x, @y, @z, @angle)
    end

    def rect
      # FlappyBean sprite's is centered at (x, y)
      # We need to calculate the top-left corner
      [@x - width/2, @y - height/2, width, height]
    end

    private

      def update_gravity
        super
        # Normalize angle
        @angle = @angle > 10 ? 10 : @angle + 4.5
      end
  end

  class Obstacle < Sprite
    def initialize(x, y, type)
      @type = type
      image =
        if top?
          Flappy::IMAGES[:obstacle_top].sample
        else
          Flappy::IMAGES[:obstacle_bottom].sample
        end
      super(image: image,
            x: x,
            y: y,
            z: Flappy::Z[:obstacle],
            vel_x: -Flappy::VEL_X)
    end

    def top?
      @type == :top
    end
  end

  class Floor < Sprite
    def initialize(x, y)
      super(image: Flappy::IMAGES[:floor],
            x: x,
            y: y,
            z: Flappy::Z[:floor],
            vel_x: -Flappy::VEL_X)
    end
  end

  class Star < Sprite
    def initialize(x, y, vel_x)
      super(image: Flappy::IMAGES[:star],
            x: x,
            y: y,
            z: Flappy::Z[:background],
            vel_x: vel_x)
    end
  end
end
