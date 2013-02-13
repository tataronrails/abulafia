class AddColumnValueToMinusTransaction < ActiveRecord::Migration
  def change
    add_column :minus_transactions, :value, :integer
  end
end
