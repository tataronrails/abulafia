class AddColumnInitialsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :initials, :string, :length => 2
    add_column :users, :first_name, :string
    add_column :users, :second_name, :string
    add_column :users, :cell, :string
    add_column :users, :im, :string
    add_column :users, :desc, :text
  end
end
