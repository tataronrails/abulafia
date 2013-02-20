class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :title
      t.references :owner, :polymorphic => true

      t.timestamps
    end
    add_index :accounts, :owner_id
  end
end
