class GamesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @all_games = Game.all
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(:white_player_id => current_user.id, :status => "pending")
    if @game.valid?
      redirect_to games_path
    else
      return render text: 'invalid game', status: :forbidden
    end     
  end

  def show
  end

  private

  def game_params
    params.require(:game).permit(:black_player_id, :white_player_id, :status, :winner_id)
  end
end
