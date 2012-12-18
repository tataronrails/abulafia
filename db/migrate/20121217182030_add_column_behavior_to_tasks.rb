class AddColumnBehaviorToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :behavior, :text
  end
end
