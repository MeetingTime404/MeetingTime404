class Game < ApplicationRecord
  has_many :chess_pieces

  after_create :populate_white_pieces
  after_create :populate_black_pieces
  
  scope :by_status, ->(status) { where(status: status) }
  scope :pending, -> { by_status('pending') }
  scope :completed, -> { by_status('completed') }
  scope :in_progress, -> { by_status('in_progress') }
  scope :recent, -> { order('games.updated_at DESC') }


  def pending?
    status == 'pending'
  end

  def white_player_won?
    status == 'white_player_won'
  end

  def black_player_won?
    status == 'black_player_won'
  end

  def game_over?
    white_player_won? || black_player_won?
  end

  def forfeit(user_id)
    if user_id == white_player_id
      update status: "black_player_won"
    elsif user_id == black_player_id
      update status: "white_player_won"
    else
      raise "Player does not exist."
    end
  end

  private
  
  def populate_white_pieces
    #"white" Game Pieces
    (0..7).each do |i|
      Pawn.create(
        game_id: id,
        x: i,
        y: 1,
        user_id: white_player_id,
        )
    end

    Rook.create(game_id: id, x: 0, y: 0, user_id: white_player_id)
    Rook.create(game_id: id, x: 7, y: 0, user_id: white_player_id)

    Knight.create(game_id: id, x: 1, y: 0, user_id: white_player_id)
    Knight.create(game_id: id, x: 6, y: 0, user_id: white_player_id)

    Bishop.create(game_id: id, x: 2, y: 0, user_id: white_player_id)
    Bishop.create(game_id: id, x: 5, y: 0, user_id: white_player_id)

    Queen.create(game_id: id, x: 3, y: 0, user_id: white_player_id)

    King.create(game_id: id, x: 4, y: 0, user_id: white_player_id)
  end

  def populate_black_pieces

    #"black" Game Pieces

    (0..7).each do |i|
      Pawn.create(
        game_id: id,
        x: i,
        y: 6,
        user_id: black_player_id,
        )
    end

    Rook.create(game_id: id, x: 0, y: 7, user_id: black_player_id)
    Rook.create(game_id: id, x: 7, y: 7, user_id: black_player_id)

    Knight.create(game_id: id, x: 1, y: 7, user_id: black_player_id)
    Knight.create(game_id: id, x: 6, y: 7, user_id: black_player_id)

    Bishop.create(game_id: id, x: 2, y: 7, user_id: black_player_id)
    Bishop.create(game_id: id, x: 5, y: 7, user_id: black_player_id)

    Queen.create(game_id: id, x: 3, y: 7, user_id: black_player_id)

    King.create(game_id: id, x: 4, y: 7, user_id: black_player_id)
  end
end
