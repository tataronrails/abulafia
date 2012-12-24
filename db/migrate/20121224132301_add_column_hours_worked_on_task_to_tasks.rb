class AddColumnHoursWorkedOnTaskToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :hours_worked_on_task, :integer
  end
end
