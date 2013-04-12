class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :title
      t.references :owner, :polymorphic => true

      t.timestamps
    end
    add_index :accounts, ['owner_id', 'owner_type'], name: 'index_accounts_on_owner'
  end
end
