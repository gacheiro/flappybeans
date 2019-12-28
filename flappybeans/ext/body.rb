module Flappy
  module Body
    attr_accessor :x, :y, :vel_x, :vel_y, :angle
    attr_accessor :allow_gravity

    def initialize_body(options = {})
      @x = options[:x] || 0
      @y = options[:y] || 0
      @vel_x = options[:vel_x] || 0
      @vel_y = options[:vel_y] || 0
      @angle = options[:angle] || 0
      @allow_gravity = options[:allow_gravity] || false
    end

    def collide?(other)
      bb_collision(rect, other.rect)
    end

    private

      def update_body
        @x += @vel_x
        @y += @vel_y
        update_gravity if @allow_gravity
      end

      def update_gravity
        max_vel = Flappy::MAX_VEL_Y
        g = Flappy::GRAVITY
        @vel_y = @vel_y > max_vel ? max_vel : @vel_y + g
      end

      def bb_collision(rect_a, rect_b)
        # Bounding box collision
        # https://developer.mozilla.org/en-US/docs/Games/Techniques/2D_collision_detection
        xa, ya, wa, ha = rect_a
        xb, yb, wb, hb = rect_b
        xa < xb + wb && xa + wa > xb && ya < yb + hb && ya + ha > yb
      end
  end
end
