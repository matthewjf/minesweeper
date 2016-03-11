require 'colorize'
class Tile
  attr_accessor :adjacent_bombs_count

  def initialize
    @reveal = false
    @bomb = false
    @adjacent_bombs_count = 0
  end

  def revealed?
    @reveal
  end

  def is_bomb?
    @bomb
  end

  def set_bomb!
    @bomb = true
  end

  def reveal!
    @reveal = true
  end

  def to_s
    if @bomb && @reveal
      "X".colorize(:red)
    elsif @reveal
      @adjacent_bombs_count == 0 ? " " : @adjacent_bombs_count.to_s.colorize(:green)
    else
      "_".colorize(:grey)
    end
  end

end
