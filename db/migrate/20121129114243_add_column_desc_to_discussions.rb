class AddColumnDescToDiscussions < ActiveRecord::Migration
  def change
    add_column :discussions, :desc, :text
  end
end
