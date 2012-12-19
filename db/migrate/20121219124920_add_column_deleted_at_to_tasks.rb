class AddColumnDeletedAtToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :deleted_at, :time
  end
end
