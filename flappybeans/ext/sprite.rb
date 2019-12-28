require_relative 'body'

module Flappy
  class Sprite
    include Body
    attr_reader :z

    def initialize(options = {})
      initialize_body(options)
      @image = options[:image] || raise("Must provide an image.")
      # The z order attribute (for drawing)
      @z = options[:z] || 0
    end

    def update
      update_body
    end

    def draw
      @image.draw(@x, @y, @z)
    end

    def width
      @image.width
    end

    def height
      @image.height
    end

    def rect
      # Return a rect (left, top, width, height)
      [x, y, width, height]
    end
  end
end
