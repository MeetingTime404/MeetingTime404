# King specific methods
class King < ChessPiece
  def valid_move?(x_target, y_target)
    return false unless super
    move_single_step?(x_target, y_target)
  end

  @@offsets =
    [{ x:  0, y:  1 },
     { x:  1, y:  1 },
     { x:  1, y:  0 },
     { x:  1, y: -1 },
     { x:  0, y: -1 },
     { x: -1, y: -1 },
     { x: -1, y:  0 },
     { x: -1, y:  1 }]

  def get_valid_moves(x, y)
    moves = get_moves_with_offsets(x, y, @@offsets)
    return get_valid_moves_with_moves(x, y, moves)
  end

end
