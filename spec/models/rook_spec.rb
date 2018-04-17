require 'rails_helper'

RSpec.describe Rook, type: :class do
  describe '.valid_move?' do
    it "should check for valid move for a Rook" do
      user = FactoryGirl.create(:user)
      piece = FactoryGirl.create(:rook, user_id: user.id)
      piece.x = 3; piece.y = 3; piece.color = "white";
      expect(piece.valid_move?(piece.x+0, piece.y+2)).to eq(true)
      expect(piece.valid_move?(piece.x+0, piece.y-2)).to eq(true)
      expect(piece.valid_move?(piece.x+3, piece.y+0)).to eq(true)
      expect(piece.valid_move?(piece.x-3, piece.y+0)).to eq(true)
      expect(piece.valid_move?(piece.x+1, piece.y+0)).to eq(true)
      expect(piece.valid_move?(piece.x+0, piece.y-1)).to eq(true)
    end
    it "should check for invalid move for a Rook" do
      user = FactoryGirl.create(:user)
      piece = FactoryGirl.create(:rook, user_id: user.id)
      piece.x = 3; piece.y = 3; piece.color = "white";
      expect(piece.valid_move?(piece.x+0, piece.y+0)).to eq(false)
      expect(piece.valid_move?(piece.x+2, piece.y+3)).to eq(false)
      expect(piece.valid_move?(piece.x-3, piece.y+4)).to eq(false)
      expect(piece.valid_move?(piece.x+0, piece.y+8)).to eq(false)
      expect(piece.valid_move?(piece.x-5, piece.y+0)).to eq(false)
    end
  end

  describe '.move_castled_rook' do
    let(:user) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:game) { FactoryGirl.create(:game)}

    it 'moves the coupled rook when the king castles' do
      white_king = FactoryGirl.create(:king, user_id: user.id, game_id: game.id)
      white_left_rook = FactoryGirl.create(:rook, x: 0, y: 0, user_id: user.id, game_id: game.id)
      white_right_rook = FactoryGirl.create(:rook, x: 7, y: 0, user_id: user.id, game_id: game.id)
      black_king = FactoryGirl.create(:king, color: 'black', x: 4, y: 7, user_id: user2.id, game_id: game.id)
      black_left_rook = FactoryGirl.create(:rook, x: 0, y: 7, color: 'black', user_id: user2.id, game_id: game.id)
      black_right_rook = FactoryGirl.create(:rook, x: 7, y: 7, color: 'black', user_id: user2.id, game_id: game.id)

      white_king.move_to(2, 0)
      white_king.reload
      white_left_rook.reload
      white_right_rook.reload
      expect(white_king.x).to eq(2)
      expect(white_left_rook.x).to eq(3)
      expect(white_right_rook.x).to eq(7)

      white_king.update_attributes(x: 4)
      white_left_rook.update_attributes(x: 0)
      white_king.reload
      white_king.move_to(6, 0)
      white_king.reload
      white_left_rook.reload
      white_right_rook.reload
      expect(white_king.x).to eq(6)
      expect(white_left_rook.x).to eq(0)
      expect(white_right_rook.x).to eq(5)
      white_right_rook.update_attributes(x: 7)

      black_king.move_to(2, 7)
      black_king.reload
      black_left_rook.reload
      black_right_rook.reload
      expect(black_king.x).to eq(2)
      expect(black_left_rook.x).to eq(3)
      expect(black_right_rook.x).to eq(7)

      black_king.update_attributes(x: 4)
      black_left_rook.update_attributes(x: 0)
      black_king.reload
      black_king.move_to(6, 7)
      black_king.reload
      black_left_rook.reload
      black_right_rook.reload
      expect(black_king.x).to eq(6)
      expect(black_left_rook.x).to eq(0)
      expect(black_right_rook.x).to eq(5)
    end
  end
end