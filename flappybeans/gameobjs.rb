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
      @vel_y = -9
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
      @image.draw_rot(@x, @y, @z, 0)
    end

    def rect
      # FlappyBean sprite's is centered at (x, y)
      # We need to calculate the top-left corner
      [@x - width/2, @y - height/2, width, height]
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

    def on_collide
      # Kill the player on collide
      :kill
    end
  end

  class Floor < Obstacle
    def initialize(x, y, z, image)
      super(x, y, z, image)
    end
  end

  class Scorable < Obstacle
    def initialize(x, y, image)
      super(x, y, 0, image)
      @scored = false
    end

    def score!
      @scored = true
      1
    end

    def on_collide
      # Increace the player's score on collide
      :score
    end

    def destroy?
      @scored
    end
  end
end
