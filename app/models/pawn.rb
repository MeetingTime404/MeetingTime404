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
          return target.color == 'white' ? true : false
        end
      else
        return true if !occupied?(x_target, y_target) # regular move
      end
    end

    false

  end

end