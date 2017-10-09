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

    it 'should change coordinates of the moved piece' do
      user1 = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game, white_player_id: user1.id)
      piece = FactoryGirl.create(:king, user_id: user1.id, game_id: game.id)
      put :update, params: { id: piece.id, x_target: 4, y_target: 4 }
      piece.reload
      expect(piece.x).to eq(4)
      expect(piece.y).to eq(4)
    end

    it 'should capture a piece' do

      user1 = FactoryGirl.create(:user)
      user2 = FactoryGirl.create(:user)
      sign_in user1
      sign_in user2

      game = FactoryGirl.create(:game, white_player_id: user1.id)

      piece1 = FactoryGirl.create(:pawn, user_id: user1.id, game_id: game.id, 
        x: 3, y: 3, color: "white")

      piece2 = FactoryGirl.create(:pawn, user_id: user2.id, game_id: game.id, 
        x: 3, y: 4, color: "black")

      put :update, params: { id: piece1.id, x_target: 3, y_target: 4 }
      piece1.reload
      piece2.reload

      expect(piece1.y).to eq(4)
      expect(piece2.captured).to eq(true)

    end

    it 'should not capture a piece; target is blank' do

      user1 = FactoryGirl.create(:user)
      user2 = FactoryGirl.create(:user)
      sign_in user1
      sign_in user2

      game = FactoryGirl.create(:game, white_player_id: user1.id)

      piece1 = FactoryGirl.create(:pawn, user_id: user1.id, game_id: game.id, 
        x: 3, y: 3, color: "white")

      piece2 = FactoryGirl.create(:pawn, user_id: user2.id, game_id: game.id, 
        x: 3, y: 5, color: "black")

      put :update, params: { id: piece1.id, x_target: 3, y_target: 4 }
      piece1.reload
      piece2.reload

      expect(piece1.y).to eq(4)
      expect(piece2.captured).to eq(false)

    end

    it 'should not capture a piece; target is of same color' do

      user1 = FactoryGirl.create(:user)
      user2 = FactoryGirl.create(:user)
      sign_in user1
      sign_in user2

      game = FactoryGirl.create(:game, white_player_id: user1.id)

      piece1 = FactoryGirl.create(:pawn, user_id: user1.id, game_id: game.id, 
        x: 3, y: 3, color: "white")

      piece2 = FactoryGirl.create(:pawn, user_id: user2.id, game_id: game.id, 
        x: 3, y: 4, color: "white")

      put :update, params: { id: piece1.id, x_target: 3, y_target: 4 }
      piece1.reload
      piece2.reload

      expect(piece1.y).to eq(3)
      expect(piece2.y).to eq(4)

    end

  end
end
