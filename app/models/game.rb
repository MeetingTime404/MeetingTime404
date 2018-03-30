class Game < ApplicationRecord

  class KingIsMissingError < StandardError; end

  has_many :chess_pieces

  after_create :populate_white_pieces

  scope :by_status, ->(status) { where(status: status) }
  scope :pending, -> { by_status('pending') }
  scope :completed, -> { by_status('completed') }
  scope :in_progress, -> { by_status('in_progress') }
  scope :recent, -> { order('games.updated_at DESC') }

  def player_color(user)
    white_player_id == user.id ? 'white' : 'black'
  end

  def pending?
    status == 'pending'
  end

  def completed?
    status == 'completed'
  end

  def in_progress?
    status == 'in_progress'
  end

  def in_check?
    status == 'in_check'
  end

  def assign_first_turn
    update_attributes(turn: 'white')
  end

  def white_player_won?
    status == 'white_player_won'
  end

  def black_player_won?
    status == 'black_player_won'
  end

  def no_winner?
    status == 'no_winner'
  end

  def game_over?
    white_player_won? || black_player_won? || no_winner?
  end

  def forfeit(user_id)
    if user_id == white_player_id && black_player_id.nil? && pending?
      update status: "no_winner"
    elsif user_id == white_player_id
      update status: "black_player_won"
    elsif user_id == black_player_id
      update status: "white_player_won"
    else
      raise "Player does not exist."
    end
  end

  def color_in_check
    return "white" if checked_color("white")
    return "black" if checked_color("black")
    nil
  end

  def checked_color(color)
    king = get_piece('King', color)
    raise KingIsMissingError, "for the game #{id}" unless king.present?
    opponent_pieces(color).each do |opponent|
      return true if opponent.valid_move?(king.x.to_i, king.y.to_i)
    end
    false
  end

  def swap_turn
    change = turn == 'white' ? 'black' : 'white'
    update_attributes(turn: change)
  end

  def populate_white_pieces
    #"white" Game Pieces
    (0..7).each do |i|
      Pawn.create(
        game_id: id,
        x: i,
        y: 1,
        user_id: white_player_id,
        color: "white",
        captured: 'false'
        )
    end

    Rook.create(game_id: id, x: 0, y: 0, user_id: white_player_id, color: "white", captured: 'false')
    Rook.create(game_id: id, x: 7, y: 0, user_id: white_player_id, color: "white", captured: 'false')

    Knight.create(game_id: id, x: 1, y: 0, user_id: white_player_id, color: "white", captured: 'false')
    Knight.create(game_id: id, x: 6, y: 0, user_id: white_player_id, color: "white", captured: 'false')

    Bishop.create(game_id: id, x: 2, y: 0, user_id: white_player_id, color: "white", captured: 'false')
    Bishop.create(game_id: id, x: 5, y: 0, user_id: white_player_id, color: "white", captured: 'false')

    Queen.create(game_id: id, x: 3, y: 0, user_id: white_player_id, color: "white", captured: 'false')

    King.create(game_id: id, x: 4, y: 0, user_id: white_player_id, color: "white", captured: 'false')
  end

  def populate_black_pieces

    #"black" Game Pieces

    (0..7).each do |i|
      Pawn.create(
        game_id: id,
        x: i,
        y: 6,
        user_id: black_player_id,
        color: "black",
        captured: 'false'
        )
    end

    Rook.create(game_id: id, x: 0, y: 7, user_id: black_player_id, color: "black", captured: 'false')
    Rook.create(game_id: id, x: 7, y: 7, user_id: black_player_id, color: "black", captured: 'false')

    Knight.create(game_id: id, x: 1, y: 7, user_id: black_player_id, color: "black", captured: 'false')
    Knight.create(game_id: id, x: 6, y: 7, user_id: black_player_id, color: "black", captured: 'false')

    Bishop.create(game_id: id, x: 2, y: 7, user_id: black_player_id, color: "black", captured: 'false')
    Bishop.create(game_id: id, x: 5, y: 7, user_id: black_player_id, color: "black", captured: 'false')

    Queen.create(game_id: id, x: 3, y: 7, user_id: black_player_id, color: "black", captured: 'false')

    King.create(game_id: id, x: 4, y: 7, user_id: black_player_id, color: "black", captured: 'false')
  end
  
  def get_piece(type, color)
    chess_pieces.where(type: type, color: color).first
  end

  def opponent_color(color)
    color == "white" ? "black" : "white"
  end

  def opponent_pieces(color)
    chess_pieces.where(color: opponent_color(color))
  end

end
