class TasksEndAndStartMakeDatetimeInsteadDate < ActiveRecord::Migration
  def up
    change_column :tasks, :start, :datetime
    change_column :tasks, :end, :datetime
  end

  def down
    change_column :tasks, :start, :datetime
    change_column :tasks, :end, :datetime
  end
end