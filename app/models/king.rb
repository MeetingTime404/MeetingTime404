class King < ChessPiece

  # King specific methods ...
  def valid_move?(x_target, y_target)
    return false if same_location?(x_target, y_target)
    return false if !in_board?(x_target, y_target)
    return true if move_single_step?(x_target, y_target)
    return false
  end

  def is_castle_move?(x_target, y_target)
    return false if move_single_step?(x_target, y_target)
    return true if horizontal_move?(x_target, y_target)
  end

  def castle_move
    #after king moves, move rook
  end

  def valid_castle_move?
    !self.moved?
    #which rook?
    #has rook moved?
    #is there an obstruction?
  end

  def find_rook
    #find rook based on direction of move?
  end




end
