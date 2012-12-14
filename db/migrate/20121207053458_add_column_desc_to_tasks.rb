class AddColumnDescToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :desc, :text
  end
end
