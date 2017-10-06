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
    x         3
    y         0
    captured  false
    color     'white'
  end

  factory :queen do
    game
    type      'Queen'
    user_id   1
    x         4
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
    black_player_id 1
    white_player_id 2
    winner_id       nil

    factory :pending_game,  :traits => [:pending]
  end

end
