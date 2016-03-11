class Tile

  def initialize
    @reveal = true
    @bomb = false
  end

  def reveal?
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
      "B"
    elsif @reveal
      "_"
    else
      " "
    end
  end

end
