# King specific methods
class King < ChessPiece
  def valid_move?(x_target, y_target)
    return false unless super
    return true if castling?(x_target, y_target)
    move_single_step?(x_target, y_target)
  end

  def move_to(x_target, y_target)
    return false unless valid_move?(x_target, y_target)
    if illegal_move?(x_target, y_target)
      return false
    else
      game.update_attributes(status: 'in_progress')
    end
    capture(x_target, y_target) if occupied?(x_target, y_target)
    update_attributes(x: x_target, y: y_target)
    game.update_attributes(status: "in_check") if checking?
    if castling?(x_target, y_target)
      rook = castling_rook(x_target, y_target)
      rook.move_castled_rook(x_target, y_target)
    end
    true
  end

  def castling?(x_target, y_target)
    return false unless allowed_castling_target?(x_target, y_target)
    # king has not moved
    return false if moved_yet?
    # rook has not moved
    castled_rook = castling_rook(x_target, y_target)
    return false if castled_rook.moved_yet?
    # not in check
    return false if game.status == 'in_check'
    # no space that king moves through is in check or is occupied
    direction = x_target > x ? 1 : -1
    return false if king_in_check?((x + direction), y_target) || occupied?((x + direction), y_target)
    true
  end

  def allowed_castling_target?(x_target, y_target)
    if color == 'white'
      return true if (x_target == 2 || x_target == 6) && y_target == 0
    else
      return true if (x_target == 2 || x_target == 6) && y_target == 7
    end
    false
  end

  def castling_rook(x_target, y_target)
    king_target = [x_target, y_target]
    case king_target
      when [2, 0]
        return game.chess_pieces.where(x: 0, y: 0).first
      when [6, 0]
        return game.chess_pieces.where(x: 7, y: 0).first
      when [2, 7]
        return game.chess_pieces.where(x: 0, y: 7).first
      when [6, 7]
        return game.chess_pieces.where(x: 7, y: 7).first
      else
        nil
    end
  end
end
