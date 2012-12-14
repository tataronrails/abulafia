class AddColumnHcUserIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hc_user_id, :integer
  end
end
