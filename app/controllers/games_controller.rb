class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
  end

  def show
  end

  private

  def game_params
    params.require(:game).permit(:black_player_id, :white_player_id, :status, :winner_id)
  end


end
