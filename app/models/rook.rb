# Rook specific methods ...
class Rook < ChessPiece
  def valid_move?(x_target, y_target)
    return false unless super
    vertical_move?(x_target, y_target) || horizontal_move?(x_target, y_target)
  end

  def move_castled_rook(x_target, y_target)
    king_target = [x_target, y_target]
    case king_target
      when [2, 0]
        update_attributes(x: 3, y: 0)
      when [6, 0]
        update_attributes(x: 5, y: 0)
      when [2, 7]
        update_attributes(x: 3, y: 7)
      when [6, 7]
        update_attributes(x: 5, y: 7)
      else
        nil
    end
  end
end
