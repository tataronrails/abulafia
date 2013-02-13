class CreatePlusTransactions < ActiveRecord::Migration
  def change
    create_table :plus_transactions do |t|
      t.integer :source_user
      t.text :desc

      t.timestamps
    end
  end
end
