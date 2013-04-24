class AddKindColumnToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :kind, :string, default: 'client'
    add_index :accounts, :kind

    Account.where(kind: 'system', title: 'External payments account').first_or_create
  end
end
