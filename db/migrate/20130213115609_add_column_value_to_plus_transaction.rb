class AddColumnValueToPlusTransaction < ActiveRecord::Migration
  def change
    add_column :plus_transactions, :value, :integer
  end
end
