require 'rails_helper'

RSpec.describe ChessPiecesController, type: :controller do
  
  describe 'chess_pieces#create' do
    it "should create dummy King" do
      king = FactoryGirl.create(:king)
      expect(king.game_id).to eq(1)
      expect(king.user_id).to eq(1)
      expect(king.x).to eq(1)
      expect(king.y).to eq(2)
      expect(king.captured).to eq(false)
      expect(king.type).to eq('King')
    end
    it "should allow creating a King" do
      post :create, params: { chess_piece: { user_id: 1, game_id: 1, x: 1, y: 2, captured: false, type: 'King' } }
      expect(King.last.user_id).to eq(1)
      expect(King.last.x).to eq(1)
      expect(King.last.y).to eq(2)
      expect(King.last.captured).to eq(false)
      expect(ChessPiece.last.type).to eq('King')
    end
    it "should check for a valid move for a King" do
      x= 0; y=0; type="King" # piece at 0,0
      post :create, params: { chess_piece: { user_id: 1, game_id: 1, x: x, y: y, captured: false, type: type } }
      king = King.last
      expect(king.valid_move?(0,1)).to eq(true)
      expect(king.valid_move?(1,0)).to eq(true)
      expect(king.valid_move?(0,0)).to eq(false)
      expect(king.valid_move?(1,1)).to eq(false)
      expect(king.valid_move?(2,2)).to eq(false)
      expect(king.valid_move?(-1,0)).to eq(false)
    end

    it "should check for a valid move for a Rook" do
      x= 2; y=0; type="Rook" # piece at 2,0
      post :create, params: { chess_piece: { user_id: 1, game_id: 1, x: x, y: y, captured: false, type: type } }
      rook = Rook.last
      expect(rook.valid_move?(4,2)).to eq(true)
      expect(rook.valid_move?(1,1)).to eq(true)
      expect(rook.valid_move?(2,0)).to eq(false)
      expect(rook.valid_move?(3,2)).to eq(false)
      expect(rook.valid_move?(-1,0)).to eq(false)
    end
  end

end