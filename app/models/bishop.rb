# Bishop specific methods
class Bishop < ChessPiece

  def valid_move?(x_target, y_target)
    return false unless super
    return true if diagonal_move?(x_target, y_target)
    false
  end

  def get_valid_moves(x, y)
    moves = get_diagonal_moves(x, y)
    return get_valid_moves_with_moves(x, y, moves)
  end

end
