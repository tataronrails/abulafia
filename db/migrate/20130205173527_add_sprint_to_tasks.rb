class AddSprintToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :sprint_id, :integer

    add_index :tasks, :sprint_id
  end
end
