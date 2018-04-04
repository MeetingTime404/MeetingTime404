require 'rails_helper'

RSpec.describe King, type: :class do

  describe '.valid_move?' do
    let(:user) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:game) { FactoryGirl.create(:game, white_player_id: user.id, black_player_id: user2.id) }

    it "should check for valid move for a King" do
      piece = FactoryGirl.create(:king, user_id: user.id)
      piece.x = 4; piece.y = 4; piece.color = "white"
      expect(piece.valid_move?(piece.x+1, piece.y+0)).to eq(true) 
      expect(piece.valid_move?(piece.x-1, piece.y+0)).to eq(true)
      expect(piece.valid_move?(piece.x+0, piece.y+1)).to eq(true)
      expect(piece.valid_move?(piece.x+0, piece.y-1)).to eq(true)
      expect(piece.valid_move?(piece.x+1, piece.y-1)).to eq(true)
      expect(piece.valid_move?(piece.x-1, piece.y-1)).to eq(true)
      expect(piece.valid_move?(piece.x+1, piece.y+1)).to eq(true)
      expect(piece.valid_move?(piece.x-1, piece.y+1)).to eq(true)
    end

    it 'returns true for a castling move' do
      game.chess_pieces.update_all(x: nil, y: nil, captured: true)
      king = FactoryGirl.create(:king, color: 'white', game_id: game.id, user_id: user.id)
      white_left_rook = FactoryGirl.create(:rook, color: 'white', game_id: game.id, user_id: user.id, x: 0, y: 0)
      white_right_rook = FactoryGirl.create(:rook, color: 'white', game_id: game.id, user_id: user.id, x: 7, y: 0)
      expect(king.valid_move?(2, king.y)).to eq(true) #castling
      expect(king.valid_move?(6, king.y)).to eq(true) #castling
    end

    it "should check for invalid move for a King" do
      piece = FactoryGirl.create(:king, user_id: user.id)
      piece.x = 4; piece.y = 4; piece.color = "white"
      expect(piece.valid_move?(piece.x+0, piece.y+0)).to eq(false)
      expect(piece.valid_move?(piece.x+2, piece.y+0)).to eq(false)
      expect(piece.valid_move?(piece.x-3, piece.y+0)).to eq(false)
      expect(piece.valid_move?(piece.x+0, piece.y+2)).to eq(false)
      expect(piece.valid_move?(piece.x+0, piece.y-3)).to eq(false)
      expect(piece.valid_move?(piece.x+2, piece.y-3)).to eq(false)
    end
  end

  describe '.castling?' do
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:game) { FactoryGirl.create(:game, white_player_id: user1.id, black_player_id: user2.id) }
    
    it 'returns true for a valid castling' do
      game.chess_pieces.update_all(x: nil, y: nil, captured: true)
      white_king = FactoryGirl.create(:king, game_id: game.id, user_id: user1.id)
      white_left_rook = FactoryGirl.create(:rook, color: 'white', game_id: game.id, user_id: user1.id, x: 0, y: 0)
      white_right_rook = FactoryGirl.create(:rook, color: 'white', game_id: game.id, user_id: user1.id, x: 7, y: 0)
      expect(white_left_rook.moved_yet?).to eq(false)
      expect(white_king.castling?(2, 0)).to eq(true)
    end

    it 'does not allow castling if the King has moved' do
      game.populate_white_pieces
      game.populate_black_pieces
      black_king = ChessPiece.last
      black_king.update_attributes(x: 4, y: 6)
      black_king.update_attributes(x: 4, y: 7)
      expect(black_king.type).to eq('King')
      expect(black_king.color).to eq('black')
      expect(black_king.castling?(6, 7)).to eq(false)
    end

    it 'does not allow castling if rook has moved' do
      game.populate_white_pieces
      game.populate_black_pieces
      white_left_rook = ChessPiece.where(x: 0, y: 0).first
      white_king = ChessPiece.where(x: 4, y: 0).first
      white_left_rook.update_attributes(x: 4, y: 4)
      white_left_rook.update_attributes(x: 0, y: 0)
      expect(white_left_rook.type).to eq('Rook')
      expect(white_left_rook.color).to eq('white')
      expect(white_king.castling?(2, 0)).to eq(false)
    end

    it 'does not allow castling if game is in check' do
      game.populate_white_pieces
      game.populate_black_pieces
      black_king = ChessPiece.last
      game.update_attributes(status: 'in_check')
      expect(black_king.castling?(6, 7)).to eq(false)
    end

    it 'does not allow castling if crossed square is in check' do
      white_king = FactoryGirl.create(:king, game_id: game.id, user_id: user1.id)
      white_left_rook = FactoryGirl.create(:rook, game_id: game.id, user_id: user1.id)
      black_bishop = FactoryGirl.create(:bishop, game_id: game.id, user_id: user2.id, color: 'black', x: 6, y: 4)
      expect(white_king.castling?(2, 0)).to eq(false)
    end
  end

  describe '.castling_rook' do
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:game) { FactoryGirl.create(:game, white_player_id: user1.id, black_player_id: user2.id) }
    
    it 'returns the coupling rook for castling' do
      game.populate_white_pieces
      game.populate_black_pieces
      black_king = ChessPiece.where(type: 'King', color: 'black').first
      white_king = ChessPiece.where(type: 'King', color: 'white').first
      white_left_rook = white_king.castling_rook(2, 0)
      expect(white_left_rook.type).to eq('Rook')
      expect(white_left_rook.x).to eq(0)
      expect(white_left_rook.y).to eq(0)

      white_right_rook = white_king.castling_rook(6, 0)
      expect(white_right_rook.type).to eq('Rook')
      expect(white_right_rook.x).to eq(7)
      expect(white_right_rook.y).to eq(0)

      black_left_rook = black_king.castling_rook(2, 7)
      expect(black_left_rook.type).to eq('Rook')
      expect(black_left_rook.x).to eq(0)
      expect(black_left_rook.y).to eq(7)

      black_right_rook = black_king.castling_rook(6, 7)
      expect(black_right_rook.type).to eq('Rook')
      expect(black_right_rook.x).to eq(7)
      expect(black_right_rook.y).to eq(7)
    end
  end

  describe '.allowed_castling_target?' do
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:game) { FactoryGirl.create(:game, white_player_id: user1.id, black_player_id: user2.id) }
    
    it 'returns true if target square is a legal castling square' do
      game.populate_white_pieces
      game.populate_black_pieces
      black_king = ChessPiece.where(type: 'King', color: 'black').first
      white_king = ChessPiece.where(type: 'King', color: 'white').first

      expect(white_king.allowed_castling_target?(2, 0)).to eq(true)
      expect(white_king.allowed_castling_target?(6, 0)).to eq(true)
      expect(black_king.allowed_castling_target?(2, 7)).to eq(true)
      expect(black_king.allowed_castling_target?(6, 7)).to eq(true)
    end
  end
end