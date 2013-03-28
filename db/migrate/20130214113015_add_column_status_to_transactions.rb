class AddColumnStatusToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :status, :integer
    add_index :transactions, :status
  end
end
