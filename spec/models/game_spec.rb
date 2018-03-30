require 'rails_helper'

RSpec.describe Game, type: :model do
  describe '.pending' do
    let(:game) { FactoryGirl.create :game, :pending }

    it 'is pending' do
      expect(game.status).to eq 'pending'
    end

    it 'is not completed' do
      expect(game.pending?).to eq true
    end
  end

  describe '.completed' do
    let(:game) { FactoryGirl.create :game, :completed }

    it 'is completed' do
      expect(game.status).to eq 'completed'
    end

    it 'is not pending' do
      expect(game.pending?).to eq false
    end
  end

  describe '.in_progress' do
    let(:game) { FactoryGirl.create :game, :in_progress }

    it 'is completed' do
      expect(game.status).to eq 'in_progress'
    end

    it 'is not pending' do
      expect(game.pending?).to eq false
    end
  end

  describe '.assign_turn' do
    it 'should assign turn to white' do
      user1 = FactoryGirl.create(:user)
      user2 = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game, white_player_id: user1.id, black_player_id: user2.id)
      game.assign_first_turn
      expect(game.turn).to eq('white')
    end
  end

  describe '.swap_turn' do
    it 'should change turn after a move' do
      user1 = FactoryGirl.create(:user)
      user2 = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game, white_player_id: user1.id, black_player_id: user2.id)
      game.assign_first_turn
      game.swap_turn
      game.reload
      expect(game.turn).to eq('black')
    end
  end

  describe '.white_player_won?' do
    let(:game) { FactoryGirl.create :game, :white_player_won }

    it 'is white_player_won' do
      expect(game.status).to eq 'white_player_won'
    end

    it 'is not completed' do
      expect(game.white_player_won?).to eq true
    end
  end

  describe '.black_player_won?' do
    let(:game) { FactoryGirl.create :game, :black_player_won }

    it 'is black_player_won' do
      expect(game.status).to eq 'black_player_won'
    end

    it 'is not completed' do
      expect(game.black_player_won?).to eq true
    end
  end

  describe '.no_winner?' do
    let(:game) { FactoryGirl.create :game, :no_winner }

    it 'is no winner' do
      expect(game.status).to eq 'no_winner'
    end

    it 'is not completed' do
      expect(game.no_winner?).to eq true
    end
  end

  describe '.game_over?' do
    
    it 'returns true if the black player has won' do
      game = FactoryGirl.create :game, :black_player_won
      expect(game.game_over?).to eq true
    end

    it 'returns true if the white player has won' do
      game = FactoryGirl.create :game, :white_player_won
      expect(game.game_over?).to eq true
    end

    it 'returns true if no forfeit is declared before a second player joins' do
      game = FactoryGirl.create :game, :no_winner
      expect(game.game_over?).to eq true
    end
  end

  describe '.populate_white_pieces' do
    let(:user1) { FactoryGirl.create(:user) }
    let(:game) { FactoryGirl.create :game, white_player_id: user1.id }

    it 'adds a white pawn at x_position: 0 through 7, y_position: 1' do
      expect(Pawn.where(game_id: game.id, x: (0..7), y: 1, user_id: game.white_player_id).first).not_to be_nil
    end
  
    it 'adds a white rook at x_position: 0 and 7, y_position: 0' do
      expect(Rook.where(game_id: game.id, x: 0, y: 0, user_id: game.white_player_id).first).not_to be_nil
      expect(Rook.where(game_id: game.id, x: 7, y: 0, user_id: game.white_player_id).first).not_to be_nil
    end

    it 'adds a white knight at x_position: 1 and 6, y_position: 0' do
      expect(Knight.where(game_id: game.id, x: 1, y: 0, user_id: game.white_player_id).first).not_to be_nil
      expect(Knight.where(game_id: game.id, x: 6, y: 0, user_id: game.white_player_id).first).not_to be_nil
    end

    it 'adds a white bishop at x_position: 2 and 5, y_position: 0' do
      expect(Bishop.where(game_id: game.id, x: 2, y: 0, user_id: game.white_player_id).first).not_to be_nil
      expect(Bishop.where(game_id: game.id, x: 5, y: 0, user_id: game.white_player_id).first).not_to be_nil
    end
  
    it 'adds a white queen at x_position: 3, y_position: 0' do
      expect(Queen.where(game_id: game.id, x: 3, y: 0, user_id: game.white_player_id).first).not_to be_nil
    end

    it 'adds a white king at x_position: 4, y_position: 0' do
      expect(King.where(game_id: game.id, x: 4, y: 0, user_id: game.white_player_id).first).not_to be_nil
    end
  end

  describe '.populate_black_pieces' do
    let(:user2) { FactoryGirl.create(:user) }
    let(:game) { FactoryGirl.create :game, black_player_id: user2.id }

    it 'adds a black pawn at x_position: 0 through 7, y_position: 6' do
      game.populate_black_pieces
      expect(Pawn.where(game_id: game.id, x: (0..7), y: 6, user_id: game.black_player_id).first).not_to be_nil
    end

    it 'adds a black rook at x_position: 0 and 7, y_position: 7' do
      game.populate_black_pieces
      expect(Rook.where(game_id: game.id, x: 0, y: 7, user_id: game.black_player_id).first).not_to be_nil
      expect(Rook.where(game_id: game.id, x: 7, y: 7, user_id: game.black_player_id).first).not_to be_nil
    end

    it 'adds a black knight at x_position: 1 and 6, y_position: 7' do
      game.populate_black_pieces
      expect(Knight.where(game_id: game.id, x: 1, y: 7, user_id: game.black_player_id).first).not_to be_nil
      expect(Knight.where(game_id: game.id, x: 6, y: 7, user_id: game.black_player_id).first).not_to be_nil
    end

    it 'adds a black bishop at x_position: 2 and 5, y_position: 0' do
      game.populate_black_pieces
      expect(Bishop.where(game_id: game.id, x: 2, y: 7, user_id: game.black_player_id).first).not_to be_nil
      expect(Bishop.where(game_id: game.id, x: 5, y: 7, user_id: game.black_player_id).first).not_to be_nil
    end

    it 'adds a black queen at x_position: 3, y_position: 7' do
      game.populate_black_pieces
      expect(Queen.where(game_id: game.id, x: 3, y: 7, user_id: game.black_player_id).first).not_to be_nil
    end

    it 'adds a black king at x_position: 4, y_position: 7' do
      game.populate_black_pieces
      expect(King.where(game_id: game.id, x: 4, y: 7, user_id: game.black_player_id).first).not_to be_nil
    end
  end

  describe 'games#forfeit' do
    let(:game) { FactoryGirl.create :game }
    context 'if there is no black player' do
      let(:game) { FactoryGirl.create :game, :pending, black_player_id: nil }
      it 'marks no player has won if player forfeits before an opponent joins' do
        game.forfeit(game.white_player_id)
        expect(game.no_winner?).to eq true
      end

      it 'ends the game if player forfeits before an opponent joins' do
        game.forfeit(game.white_player_id)
        expect(game.game_over?).to eq true
      end
    end

    context 'if there is a black player' do
      it 'marks white player has won if black player forfeits' do
        game.forfeit(game.black_player_id)
        expect(game.white_player_won?).to eq true
      end

      it 'marks black player has won if white player forfeits' do
        game.forfeit(game.white_player_id)
        expect(game.black_player_won?).to eq true
      end
    end
    it 'raises an error if an invalid user_id is provided' do
      expect{game.forfeit(0)}.to raise_error("Player does not exist.")
    end
  end

  # rspec for color_in_check the "normal" way
  describe '#color_in_check' do
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:game) { FactoryGirl.create(:game, white_player_id: user1.id, black_player_id: user2.id) }
    it 'should return nil - nothing in check' do
      king1 = game.get_piece('King', 'white')
      king2 = FactoryGirl.create(:king, color: 'black', game_id: game.id, user_id: user2.id)
      king1.update_attributes(x: 3, y: 3)
      king2.update_attributes(x: 7, y: 6)
      expect(game.color_in_check).to eq(nil)
    end
    it 'should return white - white in check' do
      king1 = game.get_piece('King', 'white')
      queen2 = FactoryGirl.create(:queen, color: 'black', game_id: game.id, user_id: user2.id)
      king1.update_attributes(x: 3, y: 3)
      queen2.update_attributes(x: 3, y: 6)
      expect(game.color_in_check).to eq('white')
    end
    it 'should return black - black in check' do
      queen1 = game.get_piece('Queen', 'white')
      king2 = FactoryGirl.create(:king, color: 'black', game_id: game.id, user_id: user2.id)
      queen1.update_attributes(x: 3, y: 3)
      king2.update_attributes(x: 3, y: 6)
      expect(game.color_in_check).to eq('black')
    end
  end  

  describe '#color_in_check unit test' do
    subject(:color_in_check) { game.color_in_check }
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:game) { FactoryGirl.create(:game, white_player_id: user1.id, black_player_id: user2.id) }
    context 'when nothing in check' do
      before do
        allow(game).to receive(:checked_color).and_return(false)
      end
      it { is_expected.to eq nil }
    end
    context 'when white is in check' do
      before do
        allow(game).to receive(:checked_color).with("black").and_return(false)
        allow(game).to receive(:checked_color).with("white").and_return(true)
      end
      it { is_expected.to eq "white" }
    end
    context 'when black is in check' do
      before do
        allow(game).to receive(:checked_color).with("black").and_return(true)
        allow(game).to receive(:checked_color).with("white").and_return(false)
      end
      it { is_expected.to eq "black" }
    end
  end

  describe '#in_check? unit test' do
    subject(:checked_color) { game.checked_color('white') }
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:game) { FactoryGirl.create(:game, white_player_id: user1.id, black_player_id: user2.id) }
    context 'when nothing is in check' do
      let(:white_king)  { FactoryGirl.build_stubbed(:king,  color: 'white', x: 3, y: 3) }
      let(:black_king)  { FactoryGirl.build_stubbed(:king,  color: 'black', x: 6, y: 6) }
      let(:opponent_pieces) { [black_king] }
      before do
        allow(game).to receive(:get_piece).and_return(white_king)
        allow(game).to receive(:opponent_color).and_return('black')
        allow(game).to receive(:opponent_pieces).and_return(opponent_pieces)
      end
      it { is_expected.to eq false }
    end
    context 'when white is in check' do
      let(:white_king)  { FactoryGirl.build_stubbed(:king,  color: 'white', x: 3, y: 3) }
      let(:black_king)  { FactoryGirl.build_stubbed(:king,  color: 'black', x: 6, y: 6) }
      let(:black_queen) { FactoryGirl.build_stubbed(:queen, color: 'black', x: 3, y: 6) }
      let(:opponent_pieces) { [black_king, black_queen] }
      before do
        allow(game).to receive(:get_piece).and_return(white_king)
        allow(game).to receive(:opponent_color).and_return('black')
        allow(game).to receive(:opponent_pieces).and_return(opponent_pieces)
      end
      it { is_expected.to eq true }
    end
    context 'when black is in check' do
      let(:black_king)  { FactoryGirl.build_stubbed(:king,  color: 'black', x: 3, y: 3) }
      let(:white_king)  { FactoryGirl.build_stubbed(:king,  color: 'white', x: 6, y: 6) }
      let(:white_queen) { FactoryGirl.build_stubbed(:queen, color: 'white', x: 3, y: 6) }
      let(:opponent_pieces) { [white_king, white_queen] }
      before do
        allow(game).to receive(:get_piece).and_return(black_king)
        allow(game).to receive(:opponent_color).and_return('white')
        allow(game).to receive(:opponent_pieces).and_return(opponent_pieces)
      end
      it { is_expected.to eq true }
    end
  end

end
