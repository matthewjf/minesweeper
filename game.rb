require_relative 'board'
class Game
  DIFFICULTY_LEVEL = {easy: 5, normal: 10, hard: 20}

  def initialize(difficulty = :normal)
    @board = Board.new(DIFFICULTY_LEVEL[difficulty])
  end

  def run
    until game_over?
      @board.render
      take_turn
    end
    @board.render
    if game_won?
      puts "you win!"
    else
      puts "you lose!"
    end
  end

  def take_turn
    row,col = get_pos
    @board.expose_tile(row,col)
  end

  def game_over?
    @board.over?
  end

  def game_won?
    @board.won?
  end

  def get_pos
    print "enter a position x,y > "
    pos = parse_pos(gets.chomp)
    until valid_pos?(*pos)
      print "invalid input, try again"
      pos = parse_pos(gets.chomp)
    end
    pos
  end

  def parse_pos(input)
    input.split(',').map(&:to_i)
  end

  def valid_pos?(row,col)
    @board.in_range?(row,col)
  end

end


if __FILE__ == $0
  g = Game.new()
  g.run
end
