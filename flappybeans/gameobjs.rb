require_relative 'ext/sprite'

module Flappy
  class FlappyBean < Sprite
    def initialize(x, y, z, frames)
      @frames = frames
      super(image: @frames.first,
            x: x,
            y: y,
            z: z,
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
    def initialize(x, y, z, image)
      super(image: image,
            x: x,
            y: y,
            z: z,
            vel_x: -Flappy::VEL_X)
    end
  end

  class Floor < Sprite
    def initialize(x, y, z, image)
      super(image: image,
            x: x,
            y: y,
            z: z,
            vel_x: -Flappy::VEL_X)
    end
  end

  class Star < Sprite
    def initialize(x, y, z, image, vel_x)
      super(image: image,
            x: x,
            y: y,
            z: z,
            vel_x: vel_x)
    end
  end
end
