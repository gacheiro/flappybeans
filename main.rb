require_relative 'flappybeans/game'

game = Flappy::Game.new(Flappy::GAME_WIDTH,
                        Flappy::GAME_HEIGHT,
                        "Flappy Beans")
game.show
