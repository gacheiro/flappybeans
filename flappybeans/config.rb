require 'gosu'

module Flappy
  GAME_WIDTH = 290
  GAME_HEIGHT = 515
  # Movement constants
  # The player itself doesn't move horizontally.
  # Instead we move the obstacles and everything else
  VEL_X = 2
  MAX_VEL_Y = 8
  MAX_VEL_X = 5
  GRAVITY = 0.8
  # Spacing beetween top and bottom obstacles
  OBSTACLE_VSPACING = 120
  # Debug game objects' bodies
  DEBUG = false

  # Sprite (game objects) images
  _sprites = {
    :player => ["assets/fbs-10.png", "assets/fbs-11.png"],
    :obstacle_top => ["assets/fbs-05.png", "assets/fbs-07.png"],
    :obstacle_bottom => ["assets/fbs-06.png", "assets/fbs-08.png"],
    :score_obstacle => "assets/fbs-52.bmp",
    :background => "assets/fbs-49.png",
    :floor => "assets/fbs-04.png",
    :digits => [
      "assets/fbs-35.png",
      "assets/fbs-36.png",
      "assets/fbs-37.png",
      "assets/fbs-38.png",
      "assets/fbs-39.png",
      "assets/fbs-40.png",
      "assets/fbs-41.png",
      "assets/fbs-42.png",
      "assets/fbs-43.png",
      "assets/fbs-44.png",
    ]
  }
  # Load the images into Gosu::Image instances
  IMAGES = {}
  _sprites.each do |key, value|
    IMAGES[key] =
      if value.is_a?(Array)
        value.map { | i | Gosu::Image.new(i) }
      else
        Gosu::Image.new(value)
      end
  end

  # Z draw orders
  Z = {
    :background => 0,
    :obstacle => 1,
    :floor => 2,
    :player => 3,
    :ui => 4,
    :debug => 5,
  }
end
