class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :current_game, only: [:show]
  before_action :chess_pieces, only: [:show]

  def index
    @all_games = Game.all
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(:white_player_id => current_user.id, :status => "pending")
    if @game.valid?
      redirect_to game_path(@game)
    else
      return render text: 'invalid game', status: :forbidden
    end     
  end

  def show; end

  private

  def chess_pieces
    @chess_pieces ||= current_game.chess_pieces
  end

  def current_game
    @game ||= Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:black_player_id, :white_player_id, :status, :winner_id)
  end
end
