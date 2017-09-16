class CreateMoves < ActiveRecord::Migration[5.0]
  def change
    create_table :moves do |t|
      t.integer :user_id
      t.integer :game_id
      t.string  :type
      t.string  :x1
      t.string  :y1
      t.string  :x2
      t.string  :y2
      t.timestamps
    end
  end
end
