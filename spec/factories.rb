FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "test#{n}@test.user"
    end
    password 'mypassword'
    password_confirmation 'mypassword'
  end

  factory :rook do
    game
    type      'Rook'
    user_id   1
    x         0
    y         0
    captured  false
    color     'white'
  end

  factory :knight do
    game
    type      'Knight'
    user_id   1
    x         1
    y         0
    captured  false
    color     'white'
  end

  factory :bishop do
    game
    type      'Bishop'
    user_id   1
    x         2
    y         0
    captured  false
    color     'white'
  end

  factory :king do
    game
    type      'King'
    user_id   1
    x         4
    y         0
    captured  false
    color     'white'
  end

  factory :queen do
    game
    type      'Queen'
    user_id   1
    x         3
    y         0
    captured  false
    color     'white'
  end

  factory :pawn do
    game
    type      'Pawn'
    user_id   1
    x         0
    y         1
    captured  false
    color     'white'
  end

  factory :game do

    black_player_id 1
    white_player_id 2
    winner_id       nil
    turn            'white'

    trait :pending do
      status 'pending'
      black_player_id nil
    end

    trait :completed do
      status 'completed'
    end

    trait :in_progress do
      status 'in_progress'
    end

    trait :white_player_won do
      status 'white_player_won'
    end

    trait :black_player_won do
      status 'black_player_won'
    end

    trait :no_winner do
      status 'no_winner'
    end

    trait :populated do
      user1 = user
      user2 = user
      after(:create) do |game|
        game.update_attributes(white_player_id: user1.id, black_player_id: user2.id)
        game.populate_white_pieces
        game.populate_black_pieces
      end
    end

    factory :pending_game,  :traits => [:pending]
  end

end
