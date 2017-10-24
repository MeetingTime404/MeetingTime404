require 'rails_helper'

RSpec.describe Pawn, type: :class do
  describe '.valid_move?' do
    it "should check for valid & invalid move for a white Pawn (starting point)" do
      user = FactoryGirl.create(:user)
      piece = FactoryGirl.create(:pawn, user_id: user.id)
      piece.x = 2; piece.y = 1; piece.color = "white";
      expect(piece.valid_move?(piece.x+0, piece.y+1)).to eq(true) 
      expect(piece.valid_move?(piece.x+1, piece.y+1)).to eq(true)
      expect(piece.valid_move?(piece.x-1, piece.y+1)).to eq(true)
      expect(piece.valid_move?(piece.x+0, piece.y+2)).to eq(true)   # up 2 steps
      expect(piece.valid_move?(piece.x+0, piece.y-1)).to eq(false)  # invalid move - back 1 step
      expect(piece.valid_move?(piece.x+0, piece.y+3)).to eq(false)  # invalid move - up 3 steps
      expect(piece.valid_move?(piece.x+2, piece.y+0)).to eq(false)
      expect(piece.valid_move?(piece.x-2, piece.y+0)).to eq(false)
      expect(piece.valid_move?(piece.x+2, piece.y+2)).to eq(false)
    end
    it "should check for valid & invalid move for a black Pawn (starting point)" do
      user = FactoryGirl.create(:user)
      piece = FactoryGirl.create(:pawn, user_id: user.id)
      piece.x = 1; piece.y = 6; piece.color = "black";
      expect(piece.valid_move?(piece.x+0, piece.y-1)).to eq(true)   # down 1 step
      expect(piece.valid_move?(piece.x-1, piece.y-1)).to eq(true)
      expect(piece.valid_move?(piece.x+0, piece.y-2)).to eq(true)   # down 2 steps
      expect(piece.valid_move?(piece.x+0, piece.y+1)).to eq(false) # invalid move - back 1 step
    end
  end

  describe '.white_pawn_just_moved_two?' do
    it "should check for if white Pawn just moved two spaces for its first move" do
      user = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game)
      piece = FactoryGirl.create(:pawn, user_id: user.id, game_id: game.id)
      piece.x = 2; piece.y = 1; piece.color = "white";
      expect(piece.white_pawn_just_moved_two?(piece.x+0, piece.y+2)).to eq(true)
      expect(piece.white_pawn_just_moved_two?(piece.x+0, piece.y+1)).to eq(false)
      expect(piece.white_pawn_just_moved_two?(piece.x+0, piece.y+3)).to eq(false)
      #white pawn just made first move of two steps
    end
  end

  describe '.black_pawn_just_moved_two?' do
    it "should check for if black Pawn just moved two spaces for its first move" do
      user = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game)
      piece = FactoryGirl.create(:pawn, user_id: user.id, game_id: game.id)
      piece.x = 1; piece.y = 6; piece.color = "black";
      expect(piece.black_pawn_just_moved_two?(piece.x+0, piece.y-2)).to eq(true)
      expect(piece.black_pawn_just_moved_two?(piece.x+0, piece.y-1)).to eq(false)
      expect(piece.black_pawn_just_moved_two?(piece.x+0, piece.y-0)).to eq(false)
      #black pawn just made first move of two steps
    end
  end

  describe '.en_passant' do
    it "should check for valid en passant capture by a black Pawn" do
      user1 = FactoryGirl.create(:user)
      user2 = FactoryGirl.create(:user)
      sign_in user1
      sign_in user2
      game = FactoryGirl.create(:game)
      piece1 = FactoryGirl.create(:pawn, user_id: user1.id, game_id: game_id)
      #white pawn just made first move of two steps
      piece1.x = 2; piece1.y = 1; piece1.color = "white"; piece1.white_pawn_just_moved_two? == true;
      piece2 = FactoryGirl.create(:pawn, user_id: user2.id, game_id: game_id)
      piece2.x = 3; piece2.y = 3; piece2.color = "black";
      #black pawn could have made capture if pawn had moved only one step
      put :update, params: { id: piece2.id, x_target: piece1.x, y_target: piece1.y }
      piece1.reload
      piece2.reload
      #black pawn makes capture
      expect(piece2.y).to eq(piece1.y)
      expect(piece1.captured).to eq(true)
    end

    it "should check for valid en passant capture by a white Pawn" do
      user = FactoryGirl.create(:user)
      piece = FactoryGirl.create(:pawn, user_id: user.id)
      piece.x = 1; piece.y = 6; piece.color = "black";
      #white pawn just made first move of two steps
      #black pawn could have made capture if pawn had moved only one step
      #black pawn makes capture
    end
  end
end