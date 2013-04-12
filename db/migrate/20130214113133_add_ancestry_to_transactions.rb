class AddAncestryToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :ancestry, :string
    add_index :transactions, :ancestry
  end
end
