class AddColumnAcceptedToStartToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :accepted_to_start, :datetime
  end
end
