require 'byebug'
require_relative 'tile'
class Board
  def initialize(grid_size = 9, bombs_count = grid_size)
    @grid = Array.new(grid_size){Array.new(grid_size){Tile.new}}
    add_bombs(bombs_count)
  end

  def [](row,col)
    @grid[row][col]
  end

  def render
    puts '  ' + (0...@grid.size).map(&:to_s).join(' ')
    @grid.each.with_index do |row,i|
      puts "#{i} " + row.map(&:to_s).join(' ')
    end
  end

  def adjacent_positions(row,col)
    rows = [row - 1, row, row + 1]
    cols = [col - 1, col, col + 1]
    rows.product(cols).select do |r,c|
      grid_indices = (0...@grid.size)
      grid_indices.include?(r) && grid_indices.include?(c) &&
        !(r == row && c == col)
    end
  end

  def adjacent_bombs_count(row,col)
    # byebug
    adjacent_positions(row,col).count { |row,col| @grid[row][col].is_bomb? }
  end

  private
  def add_bombs(bombs_count)
    indices = (0...@grid.size).to_a
    positions = indices.product(indices)
    bomb_pos = positions.shuffle.take(bombs_count)

    bomb_pos.each do |pos|
      row, col = pos
      @grid[row][col].set_bomb!
    end
  end
end
