# Pawn specific methods ...
class Pawn < ChessPiece

  def valid_move?(x_target, y_target)

    return false unless super
    return true if color == 'white' && y == 1 && x == x_target && y_target == 3 # 1st move & 2 steps
    return true if color == 'black' && y == 6 && x == x_target && y_target == 4 # 1st move & 2 steps

    # checking for regular & capture move for white
    if color == 'white' && move_single_step?(x_target, y_target) && y_target == y + 1
      if (x_target - x).abs == 1
        if occupied?(x_target, y_target) # capture move
          target = ChessPiece.where(game_id: game_id, x: x_target, y: y_target).first
          return target.color == 'black' ? true : false
        end
      else
        return true if !occupied?(x_target, y_target) # regular move
      end
    end

    # checking for regular & capture move for black
    if color == 'black' && move_single_step?(x_target, y_target) && y_target == y - 1
      if (x_target - x).abs == 1
        if occupied?(x_target, y_target) # capture move
          target = ChessPiece.where(game_id: game_id, x: x_target, y: y_target).first
          return target.color == 'black' ? true : false
        end
      else
        return true if !occupied?(x_target, y_target) # regular move
      end
    end
    false
  end

  def white_pawn_just_moved_two?(x_target, y_target)
    return true if valid_move?(x_target, y_target) && color == 'white' && y == 1 && x == x_target && y_target == 3
    false
  end

  def black_pawn_just_moved_two?(x_target, y_target)
    return true if valid_move?(x_target, y_target) && color == 'black' && y == 6 && x == x_target && y_target == 4
    false
  end

  def en_passant?(x_target, y_target)
    #black just moved two and white is in position to capture
    if color == 'white' && valid_move?(x_target, y_target) && black_pawn_just_moved_two?(x_target, y_target) &&  y == 4 && y_target == 5
      if (x_target - x).abs == 1
        if occupied?(x_target, y_target - 1) # capture move
          target = ChessPiece.where(game_id: game_id, x: x_target, y: 4).first
          return target.color == 'black' ? true : false
        end
      else
        return false # no black pawn present 
      end
    end

    #white just moved two and black is in position to capture
    if color == 'black' && valid_move?(x_target, y_target) && white_pawn_just_moved_two?(x_target, y_target) &&  y == 3 && y_target == 2
      if (x_target - x).abs == 1
        if occupied?(x_target, y_target + 1) # capture move
          target = ChessPiece.where(game_id: game_id, x: x_target, y: 3).first
          return target.color == 'white' ? true : false
        end
      else
        return false # no white pawn present 
      end
    end

  end

  def black_capture_white_en_passant(x_target, y_target)
    target = find_piece(x_target + 1 || x_target - 1, y_target + 1)
    target.update_attributes(captured: true, x: nil, y: nil) if target && color != target.color
  end

  def white_capture_black_en_passant(x_target, y_target)
    target = find_piece(x_target + 1 || x_target - 1, y_target - 1)
    target.update_attributes(captured: true, x: nil, y: nil) if target && color != target.color
  end
end
