# Rook specific methods ...
class Rook < ChessPiece

  def valid_move?(x_target, y_target)
    return false unless super
    vertical_move?(x_target, y_target) || horizontal_move?(x_target, y_target)
  end

  def get_valid_moves(x, y)
    moves_horizontal = get_diagonal_moves(x, y)
    moves_vertical = get_vertical_moves(x, y)
    return get_valid_moves_with_moves(x, y, moves_horizontal + moves_vertical)
  end

end
