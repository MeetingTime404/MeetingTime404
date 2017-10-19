require 'rails_helper'

RSpec.describe ChessPiecesController, type: :controller do
  describe 'chess_pieces#create' do
    it 'should create dummy King' do
      user = FactoryGirl.create(:user)
      king = FactoryGirl.create(:king, user_id: user.id)
      expect(king.user_id).to eq(user.id)
      expect(king.x).to eq(3)
      expect(king.y).to eq(0)
      expect(king.captured).to eq(false)
      expect(king.type).to eq('King')
    end
  end

  describe 'chess_pieces#update' do

    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:game)  { FactoryGirl.create(:game, white_player_id: user1, black_player_id: user2) }

    it 'should change coordinates of the moved piece on VALID move' do
      piece = FactoryGirl.create(:pawn, user_id: user1.id, game_id: game.id, x: 0, y: 1)
      put :update, params: { id: piece.id, x_target: 0, y_target: 2 } # 0, 1 => 0, 2
      piece.reload
      expect(piece.x).to eq(0)
      expect(piece.y).to eq(2)
    end

    it 'should NOT change coordinates of the moved piece on INVALID move' do
      piece = FactoryGirl.create(:pawn, user_id: user1.id, game_id: game.id, x: 0, y: 1)
      put :update, params: { id: piece.id, x_target: 1, y_target: 3 } # 0, 1 => 1, 3
      piece.reload
      expect(piece.x).to eq(0)
      expect(piece.y).to eq(1)
    end

    it 'should indicate check condition with the move' do
      king2   = FactoryGirl.create(
          :king,  user_id: user2.id, color: 'black', game_id: game.id, x: 6,y: 6) # king2  6, 6
      queen1  = FactoryGirl.create(
          :queen, user_id: user1.id, color: 'white', game_id: game.id, x: 1,y: 1) # queen1 1, 1
      put :update, params: { id: queen1.id, x_target: 6, y_target: 1 } # 1,1 => 6,1
      game.reload
      expect(game.status).to eq("in_check")
    end

  end

end
