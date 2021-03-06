require 'rails_helper'

RSpec.describe Pawn, type: :class do

  describe '.valid_move?' do

    it "should check for valid & invalid move for a white Pawn (starting point)" do
      user = FactoryGirl.create(:user)
      piece = FactoryGirl.create(:pawn, user_id: user.id)
      piece.x = 2; piece.y = 1; piece.color = "white";
      expect(piece.valid_move?(piece.x+0, piece.y+1)).to eq(true)   # up 1 step
      expect(piece.valid_move?(piece.x+0, piece.y+2)).to eq(true)   # up 2 steps
      expect(piece.valid_move?(piece.x+1, piece.y+1)).to eq(false)  # capture move blank
      expect(piece.valid_move?(piece.x-1, piece.y+1)).to eq(false)  # capture move blank

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
      expect(piece.valid_move?(piece.x+0, piece.y-2)).to eq(true)   # down 2 steps
      expect(piece.valid_move?(piece.x-1, piece.y-1)).to eq(false)
      expect(piece.valid_move?(piece.x+0, piece.y+1)).to eq(false) # invalid move - back 1 step
    end

  end

end