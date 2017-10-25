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

  describe 'game#populate_white_pieces action' do
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

  describe 'game#populate_black_pieces action' do
    let(:user2) { FactoryGirl.create(:user) }
    let(:game) { FactoryGirl.create :game, black_player_id: user2.id }

    it 'adds a black pawn at x_position: 0 through 7, y_position: 6' do
      expect(Pawn.where(game_id: game.id, x: (0..7), y: 6, user_id: game.black_player_id).first).not_to be_nil
    end

    it 'adds a black rook at x_position: 0 and 7, y_position: 7' do
      expect(Rook.where(game_id: game.id, x: 0, y: 7, user_id: game.black_player_id).first).not_to be_nil
      expect(Rook.where(game_id: game.id, x: 7, y: 7, user_id: game.black_player_id).first).not_to be_nil
    end

    it 'adds a black knight at x_position: 1 and 6, y_position: 7' do
      expect(Knight.where(game_id: game.id, x: 1, y: 7, user_id: game.black_player_id).first).not_to be_nil
      expect(Knight.where(game_id: game.id, x: 6, y: 7, user_id: game.black_player_id).first).not_to be_nil
    end

    it 'adds a black bishop at x_position: 2 and 5, y_position: 0' do
      expect(Bishop.where(game_id: game.id, x: 2, y: 7, user_id: game.black_player_id).first).not_to be_nil
      expect(Bishop.where(game_id: game.id, x: 5, y: 7, user_id: game.black_player_id).first).not_to be_nil
    end

    it 'adds a black queen at x_position: 3, y_position: 7' do
      expect(Queen.where(game_id: game.id, x: 3, y: 7, user_id: game.black_player_id).first).not_to be_nil
    end

    it 'adds a black king at x_position: 4, y_position: 7' do
      expect(King.where(game_id: game.id, x: 4, y: 7, user_id: game.black_player_id).first).not_to be_nil
    end
  end

  describe 'game#forfeit' do
    let(:game) { FactoryGirl.create :game }
    context 'if there is no black player' do
      let(:game) { FactoryGirl.create :game, :pending, black_player_id: nil }
      it 'marks no player as won if player forfeits before an opponent joins' do
        game.forfeit(game.white_player_id)
        expect(game.no_winner?).to eq true
      end

      it 'ends the game if player forfeits before an opponent joins' do
        game.forfeit(game.white_player_id)
        expect(game.game_over?).to eq true
      end
    end

    context 'if there is a black player' do
      it 'marks white player as won if black player forfeits' do
        game.forfeit(game.black_player_id)
        expect(game.white_player_won?).to eq true
      end

      it 'marks black player as won if white player forfeits' do
        game.forfeit(game.white_player_id)
        expect(game.black_player_won?).to eq true
      end
    end
    it 'raises an error if an invalid user_id is provided' do
      expect{game.forfeit(0)}.to raise_error("Player does not exist.")
    end
  end

  describe '#check?' do
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:game) { FactoryGirl.create(:game, white_player_id: user1.id, black_player_id: user2.id) }
    it 'should return nil - no player in check' do
      expect(game.check?).to eq(nil)
    end
    it 'should return white - white in check' do
      FactoryGirl.create(:king,  color: 'white', x: 3, y: 3, user_id: user1.id, game_id: game.id)
      FactoryGirl.create(:rook,  color: 'black', x: 1, y: 7, user_id: user2.id, game_id: game.id)
      FactoryGirl.create(:queen, color: 'black', x: 3, y: 7, user_id: user2.id, game_id: game.id)
      FactoryGirl.create(:king,  color: 'black', x: 2, y: 7, user_id: user2.id, game_id: game.id)
      expect(game.check?).to eq('white')
    end

    it 'should return black - black in check' do
      FactoryGirl.create(:king,  color: 'black', x: 3, y: 3, user_id: user1.id, game_id: game.id)
      FactoryGirl.create(:rook,  color: 'white', x: 1, y: 7, user_id: user2.id, game_id: game.id)
      FactoryGirl.create(:queen, color: 'white', x: 3, y: 7, user_id: user2.id, game_id: game.id)
      FactoryGirl.create(:king,  color: 'white', x: 1, y: 1, user_id: user2.id, game_id: game.id)
      expect(game.check?).to eq('black')
    end

  end  
end
