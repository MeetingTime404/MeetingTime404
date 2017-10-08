class AlterChessPieceAddColor < ActiveRecord::Migration[5.0]
  def change
    add_column :chess_pieces, :color, :string
  end
end
