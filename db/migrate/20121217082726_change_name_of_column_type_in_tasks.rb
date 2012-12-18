class ChangeNameOfColumnTypeInTasks < ActiveRecord::Migration
  def up
    rename_column :tasks, :type, :task_type
  end

  def down
    rename_column :tasks, :task_type, :type
  end
end
