require 'rails_helper'

RSpec.describe ChessPiece, type: :model do
  it_behaves_like 'an STI class'

  describe '#capture' do
    subject(:capture) { white_rook.capture(2, 2) }
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:white_rook) { FactoryGirl.create(:rook, color: 'white', user_id: user1.id) }
    let(:white_queen) { FactoryGirl.create(:queen, color: 'white', user_id: user1.id) }
    let(:black_queen) { FactoryGirl.create(:queen, color: 'black', user_id: user2.id) }
    before do
      allow(white_rook).to receive(:find_piece).and_return(find_piece)
    end
    context 'target is of different colors' do
      let(:find_piece) { black_queen } 
      it "should capture the target" do
        capture
        black_queen.reload
        expect(black_queen.captured).to eq true
      end
    end
    context 'target is of the same color' do
      let(:find_piece) { white_queen } 
      it "should not capture the target" do
        capture
        white_queen.reload
        expect(black_queen.captured).to eq false
      end
    end
  end

  describe '#move_to' do
    subject(:move_to) { chess_piece.move_to(2, 2) }
    let(:user) { FactoryGirl.create(:user) }
    let(:chess_piece) { FactoryGirl.create(:rook, user_id: user.id) }
    before do
      allow(chess_piece).to receive(:valid_move?).and_return(valid_move?)
    end
    context 'when move is valid' do
      let(:valid_move?) { true } 
      before do
        allow(chess_piece).to receive(:illegal_move?).and_return(illegal_move?)
      end
      context 'when move is not illegal' do
        let(:illegal_move?) { false } 
        let(:checking?) { false }         
        before do
          allow(chess_piece).to receive(:checking?).and_return(checking?)
        end
        context 'when move checks opponent' do
          let(:checking?) { true } 
          let(:game) { chess_piece.game } 
          before do
            allow(chess_piece).to receive(:checking?).and_return(checking?)
          end
          it "status should equal in_check" do
            move_to
            expect(game.status).to eq "in_check"
          end
        end
        it { is_expected.to eq true }
      end
      context 'when move is illegal' do
        let(:illegal_move?) { true } 
        it { is_expected.to eq false }
      end
    end
    context 'when move is invalid' do
      let(:valid_move?) { false } 
      it { is_expected.to eq false }
    end
  end

  describe '.obstructed?' do
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:game) { FactoryGirl.create(:game) }

    # Horizontal
    it 'should return true - Horizontal Right YES obstruction' do
      rook = FactoryGirl.create(:rook, x: 4, y: 4, user_id: user1.id, game_id: game.id)
      FactoryGirl.create(:bishop, x: 6, y: 4, user_id: user1.id, game_id: game.id)
      # start 4, 4 => 7, 4 -- piece at 6, 4
      expect(rook.obstructed?(7, 4)).to eq(true)
    end

    it 'should return false - Horizontal Right NO obstruction' do
      rook = FactoryGirl.create(:rook, x: 4, y: 4, user_id: user1.id, game_id: game.id)
      # start 4, 4 => 7, 4
      expect(rook.obstructed?(7, 4)).to eq(false)
    end

    it 'should return true - Horizontal Left YES obstruction' do
      rook = FactoryGirl.create(:rook, x: 4, y: 4, user_id: user1.id, game_id: game.id)
      FactoryGirl.create(:bishop, x: 3, y: 4, user_id: user1.id, game_id: game.id)
      # start 4, 4 => 2, 4 -- piece at 3, 4
      expect(rook.obstructed?(2, 4)).to eq(true)
    end

    it 'should return false - Horizontal Left NO obstruction' do
      rook = FactoryGirl.create(:rook, x: 4, y: 4, user_id: user1.id, game_id: game.id)
      # start 4, 4 => 2, 4
      expect(rook.obstructed?(2, 4)).to eq(false)
    end

    # Vertical
    it 'should return true - Horizontal Up YES obstruction' do
      rook = FactoryGirl.create(:rook, x: 2, y: 2, user_id: user1.id, game_id: game.id)
      FactoryGirl.create(:bishop, x: 2, y: 4, user_id: user1.id, game_id: game.id)
      # start 2, 2 => 2, 5 -- piece at 2, 4
      expect(rook.obstructed?(2, 5)).to eq(true)
    end

    it 'should return false - Horizontal Up NO obstruction' do
      rook = FactoryGirl.create(:rook, x: 2, y: 2, user_id: user1.id, game_id: game.id)
      # start 2, 2 => 2, 5
      expect(rook.obstructed?(2, 5)).to eq(false)
    end

    it 'should return true - Horizontal Down YES obstruction' do
      rook = FactoryGirl.create(:rook, x: 2, y: 5, user_id: user1.id, game_id: game.id)
      FactoryGirl.create(:bishop, x: 2, y: 4, user_id: user1.id, game_id: game.id)
      # start 2, 5 => 2, 2 piece at 2, 4
      expect(rook.obstructed?(2, 2)).to eq(true)
    end

    it 'should return false - Horizontal Down NO obstruction' do
      rook = FactoryGirl.create(:rook, x: 2, y: 5, user_id: user1.id, game_id: game.id)
      # start 2, 5 => 2, 2
      expect(rook.obstructed?(2, 2)).to eq(false)
    end

    # Diagonal
    it 'should return true - Diagonal Up Right YES obstruction' do
      rook = FactoryGirl.create(:rook, x: 2, y: 2, user_id: user1.id, game_id: game.id)
      FactoryGirl.create(:bishop, x: 4, y: 4, user_id: user1.id, game_id: game.id)
      # start 2, 2, => 5, 5 -- piece at 4, 4
      expect(rook.obstructed?(5, 5)).to eq(true)
    end

    it 'should return false - Diagonal Up Right NO obstruction' do
      rook = FactoryGirl.create(:rook, x: 2, y: 2, user_id: user1.id, game_id: game.id)
      # start 2, 2 => 5, 5
      expect(rook.obstructed?(5, 5)).to eq(false)
    end

    it 'should return true - Diagonal Up Left YES obstruction' do
      rook = FactoryGirl.create(:rook, x: 2, y: 2, user_id: user1.id, game_id: game.id)
      FactoryGirl.create(:bishop, x: 1, y: 3, user_id: user1.id, game_id: game.id)
      # start 2, 2 => 0, 4 -- piece at 1, 3
      expect(rook.obstructed?(0, 4)).to eq(true)
    end

    it 'should return false - Diagonal Up Left NO obstruction' do
      rook = FactoryGirl.create(:rook, x: 2, y: 2, user_id: user1.id, game_id: game.id)
      # start 2, 2 => 0, 4
      expect(rook.obstructed?(0, 4)).to eq(false)
    end

    it 'should return true - Diagonal Down Right YES obstruction' do
      rook = FactoryGirl.create(:rook, x: 4, y: 4, user_id: user1.id, game_id: game.id)
      FactoryGirl.create(:bishop, x: 5, y: 3, user_id: user1.id, game_id: game.id)
      # start 4, 4 => 6, 2 -- piece at 5, 3
      expect(rook.obstructed?(6, 2)).to eq(true)
    end

    it 'should return false - Diagonal Down Right NO obstruction' do
      rook = FactoryGirl.create(:rook, x: 4, y: 4, user_id: user1.id, game_id: game.id)
      # start 4, 4 => 6, 2
      expect(rook.obstructed?(6, 2)).to eq(false)
    end

    it 'should return true - Diagonal Down Left YES obstruction' do
      rook = FactoryGirl.create(:rook, x: 4, y: 4, user_id: user1.id, game_id: game.id)
      FactoryGirl.create(:bishop, x: 3, y: 3, user_id: user1.id, game_id: game.id)
      # start 4, 4 => 2, 2 -- piece at 3, 3
      expect(rook.obstructed?(2, 2)).to eq(true)
    end

    it 'should return false - Diagonal Down Left NO obstruction' do
      rook = FactoryGirl.create(:rook, x: 4, y: 4, user_id: user1.id, game_id: game.id)
      # start 4, 4 => 2, 2
      expect(rook.obstructed?(2, 2)).to eq(false)
    end
  end

  describe '.friendly_fire?' do
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:game) { FactoryGirl.create(:game) }
    let(:white_queen) { FactoryGirl.create(:queen, x: 4, y: 4, user_id: user1.id, game_id: game.id) }

    it 'should return True if target square is occupied by a same color piece' do
      FactoryGirl.create(:pawn, x: 4, y: 5, user_id: user1.id, game_id: game.id)
      expect(white_queen.friendly_fire?(4, 5)).to eq(true)
    end

    it 'should return False if target square is inoccupied' do
      expect(white_queen.friendly_fire?(3, 4)).to eq(false)
    end

    it 'should return False if target square is different color' do
      FactoryGirl.create(:pawn, x: 4, y: 3, color: 'black', user_id: user2.id, game_id: game.id)
      expect(white_queen.friendly_fire?(4, 3)).to eq(false)
    end
  end

  describe '.moved_yet?' do
    let(:user1) { FactoryGirl.create(:user) }
    let(:game) { FactoryGirl.create(:game) }
    let(:piece) { FactoryGirl.create(:queen, x: 4, y:4, user_id: user1.id, game_id: game.id) }

    it 'should return false if piece has not moved' do
      expect(piece.moved_yet?).to eq(false)
    end

    # removing this until Moves db is set up
    # it 'should return true if piece has moved' do
    #   piece.update_attributes(captured: true)
    #   expect(piece.moved_yet?).to eq(true)
    # end
  end
end
