class AddNameWinsLossesToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string
    add_column :users, :wins, :integer
    add_column :users, :losses, :integer
  end
end
