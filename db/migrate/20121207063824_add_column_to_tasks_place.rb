class AddColumnToTasksPlace < ActiveRecord::Migration
  def change
    add_column :tasks, :place, :integer, :default => 0
  end
end
