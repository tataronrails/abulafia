class CreateMinusTransactions < ActiveRecord::Migration
  def change
    create_table :minus_transactions do |t|
      t.integer :target_user
      t.references :project
      t.references :plus_transaction

      t.timestamps
    end
    add_index :minus_transactions, :project_id
  end
end