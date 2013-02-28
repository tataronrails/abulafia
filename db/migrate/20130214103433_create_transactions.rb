class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :value
      t.references :from_account
      t.references :to_account
      t.text :desc
      t.references :author

      t.timestamps
    end
    add_index :transactions, :from_account_id
    add_index :transactions, :to_account_id
    add_index :transactions, :author_id
  end
end
