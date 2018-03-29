# Knight specific methods
class Knight < ChessPiece
  # the valid offsets form its original location
  @@offsets =
    [{ x:  1, y:  2 },
     { x:  1, y: -2 },
     { x: -1, y:  2 },
     { x: -1, y: -2 },
     { x:  2, y:  1 },
     { x:  2, y: -1 },
     { x: -2, y:  1 },
     { x: -2, y: -1 }]

  # iterate through valid offsets to determine valid target locations
  def valid_move?(x_target, y_target)
    return false unless super
    @@offsets.each do |offset|
      return true if x_target == x + offset[:x] && y_target == y + offset[:y]
    end
    false
  end

  def obstructed?(*)
    false
  end

  def get_valid_moves(x, y)
    moves = get_moves_with_offsets(x, y, @@offsets)
    return get_valid_moves_with_moves(x, y, moves)
  end

end
