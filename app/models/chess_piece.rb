class ChessPiece < ApplicationRecord
  # Will have to add belongs_to :game, :user

  MIN_INDEX = 0
  MAX_INDEX = 7

  # Common methods for all pieces ...
  def valid_move?(x_target, y_target)
  end

  private

  def same_location?(x_target, y_target)
    return x == x_target && y == y_target
  end

  def in_board?(x_target, y_target)
    return x_target >= MIN_INDEX && x_target <= MAX_INDEX && 
           y_target >= MIN_INDEX && y_target <= MAX_INDEX
  end

  # check horizontal and vertical moves
  def move_straight_line?(x_target, y_target, single_step=true)
    x_dist = (x_target - x).abs
    y_dist = (y_target - y).abs
#    puts "#{x},#{y}->#{x_target},#{y_target} => #{x_dist},#{y_dist} #{single_step}"
    if single_step
        return true if (x_dist == 0 && y_dist == 1) || 
                       (x_dist == 1 && y_dist == 0)
    else
        return true if (x_dist == 0 && y_dist > 0) || 
                       (x_dist > 0 && y_dist == 0)

    end
    return false
  end

  def move_diagonally?(x_target, y_target)
    x_dist = (x_target - x).abs
    y_dist = (y_target - y).abs
    return true if x_dist == y_dist
    return false
  end

end
