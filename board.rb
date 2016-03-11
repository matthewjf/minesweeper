require 'byebug'
require_relative 'tile.rb'
class Board
  def initialize(grid_size = 9, bombs_count = grid_size)
    @grid = Array.new(grid_size){Array.new(grid_size){Tile.new}}
    add_bombs(bombs_count)
    add_bomb_counts_to_tiles
  end

  def render
    system("clear")
    puts '  ' + (0...@grid.size).map(&:to_s).join(' ')
    @grid.each.with_index do |row,i|
      puts "#{i} " + row.map(&:to_s).join(' ')
    end
    nil
  end

  def expose_tile(row,col)
    tile = @grid[row][col]
    if tile.adjacent_bombs_count > 0 && !tile.is_bomb?
      tile.reveal!
      return
    elsif tile.is_bomb?
      expose_all_bombs
      return
    else
      tile.reveal!
      return adjacent_positions(row,col).each {|r,c| expose_tile(r,c) unless @grid[r][c].revealed? }
    end
  end

  def over?
    bomb_revealed? || won?
  end

  def won?
    bomb_revealed? == false &&
      all_pos.all? do |row, col|
        tile = @grid[row][col]
        tile.revealed? || tile.is_bomb?
      end
  end

  def in_range?(row,col)
    grid_indices = (0...@grid.size)
    grid_indices.include?(row) && grid_indices.include?(col)
  end

  private
  def expose_all_bombs
    all_pos.each do |row,col|
      tile = @grid[row][col]
      tile.reveal! if tile.is_bomb?
    end
  end

  def [](row,col)
    @grid[row][col]
  end

  def get_adjacent_bombs_count(row,col)
    adjacent_positions(row,col).count { |row,col| @grid[row][col].is_bomb? }
  end

  def bomb_revealed?
    all_pos.any? do |row,col|
      tile = @grid[row][col]
      tile.revealed? && tile.is_bomb?
    end
  end

  def add_bombs(bombs_count)
    bomb_pos = all_pos.shuffle.take(bombs_count)

    bomb_pos.each do |pos|
      row, col = pos
      @grid[row][col].set_bomb!
    end
  end

  def add_bomb_counts_to_tiles
    all_pos.each do |row,col|
      @grid[row][col].adjacent_bombs_count = get_adjacent_bombs_count(row,col)
    end
  end

  def adjacent_positions(row,col)
    rows = [row - 1, row, row + 1]
    cols = [col - 1, col, col + 1]
    rows.product(cols).select do |r,c|
      in_range?(r,c) && !(r == row && c == col)
    end
  end

  def all_pos
    indices = (0...@grid.size).to_a
    positions = indices.product(indices)
  end
end
