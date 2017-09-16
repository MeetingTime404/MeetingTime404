FactoryGirl.define do
  factory :move do
    
  end

	factory :king do
		type  		"King"
		user_id	  1
		game_id		1
		x					1
		y					2
		captured 	false
	end
end
