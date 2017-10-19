# Common methods for all pieces
class ChessPiece < ApplicationRecord
  belongs_to :game
  belongs_to :user

  MIN_INDEX = 0
  MAX_INDEX = 7

  private_constant :MIN_INDEX
  private_constant :MAX_INDEX

  def move_to(x_target, y_target)
    if valid_move?(x_target.to_i, y_target.to_i)
      update_attributes(x: x_target, y: y_target)
      if check?()
        game.update_attributes(status: "in_check")
      end
    else
      false
    end
  end

  def valid_move?(x_target, y_target)
    return false if same_location?(x_target, y_target)
    return false unless in_board?(x_target, y_target)
    return false if obstructed?(x_target, y_target)
    true
  end

  def check?()
    color == "white"? opponent_color = "black" : opponent_color = "white"
    opponent_king = game.chess_pieces.where(type: 'King', color: opponent_color).first
    if opponent_king
      return valid_move?(opponent_king.x, opponent_king.y)
    end
    false
  end

  def obstructed?(x_target, y_target)
    case
      when horizontal_move?(x_target, y_target)
        horizontal_obstruction?(x_target)
      when vertical_move?(x_target, y_target)
        vertical_obstruction?(y_target)
      when diagonal_move?(x_target, y_target)
        diagonal_obstruction?(x_target, y_target)
      else
        false
    end
  end

  def horizontal_move?(x_target, y_target)
    x != x_target && y == y_target
  end

  def vertical_move?(x_target, y_target)
    x == x_target && y != y_target
  end

  def diagonal_move?(x_target, y_target)
    (x_target - x).abs == (y_target - y).abs
  end

  def horizontal_obstruction?(x_target)
    direction = x_target > x ? 1 : -1
    (x + direction).step(x_target - direction, direction) do |x_current|
      return true if occupied?(x_current, y)
    end
    false
  end

  def vertical_obstruction?(y_target)
    direction = y_target > y ? 1 : -1
    (y + direction).step(y_target - direction, direction) do |y_current|
      return true if occupied?(x, y_current)
    end
    false
  end

  def diagonal_obstruction?(x_target, y_target)
    x_direction = x_target > x ? 1 : -1
    y_direction = y_target > y ? 1 : -1
    (x + x_direction).step(x_target - x_direction, x_direction) do |x_current|
      y_current = y + ((x_current - x).abs * y_direction)
      return true if occupied?(x_current, y_current)
    end
    false
  end

  def occupied?(x_current, y_current)
    game.chess_pieces.where(x: x_current, y: y_current).present?
  end

  private

  def same_location?(x_target, y_target)
    x == x_target && y == y_target
  end

  def in_board?(x_target, y_target)
    x_target >= MIN_INDEX && x_target <= MAX_INDEX &&
    y_target >= MIN_INDEX && y_target <= MAX_INDEX
  end

  def move_single_step?(x_target, y_target)
    x_dist = (x_target - x).abs
    y_dist = (y_target - y).abs
    x_dist <= 1 && y_dist <= 1 ? true : false
  end
end
