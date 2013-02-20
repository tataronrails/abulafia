class AddAncestryToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :ancestry, :string
  end
end
