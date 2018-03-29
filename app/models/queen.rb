# Queen specific methods ...
class Queen < ChessPiece

  def valid_move?(x_target, y_target)
    return false unless super
    return true if horizontal_move?(x_target, y_target) ||
                   vertical_move?(x_target, y_target) ||
                   diagonal_move?(x_target, y_target)
    false
  end

  def get_valid_moves(x, y)
    moves_horizontal = get_diagonal_moves(x, y)
    moves_vertical = get_vertical_moves(x, y)
    moves_diagonal = get_diagonal_moves(x, y)
    return get_valid_moves_with_moves(x, y, moves_horizontal + moves_vertical + moves_diagonal)
  end

end
