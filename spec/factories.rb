FactoryGirl.define do

  factory :rook do
    game
    type      'Rook'
    user_id   1
    x         0
    y         0
    captured  false
  end

  factory :knight do
    game
    type      'Knight'
    user_id   1
    x         1
    y         0
    captured  false
  end

  factory :bishop do
    game
    type      'Bishop'
    user_id   1
    x         2
    y         0
    captured  false
  end

  factory :king do
    game
    user_id   1
    type      'King'
    x         3
    y         0
    captured  false
  end

  factory :queen do
    game
    type      'Queen'
    user_id   1
    x         4
    y         0
    captured  false
  end

  factory :pawn do
    game
    type      'Pawn'
    user_id   1
    x         0
    y         1
    captured  false
  end

  factory :game do
    trait :pending do
      status 'pending'
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
  end

  factory :user do
    email "dummyEmail@gmail.com"
    password "smartPassword"
    password_confirmation "smartPassword"
  end
end
