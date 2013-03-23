class AddAssignedUserColToTask < ActiveRecord::Migration
  def up
    #remove_column :tasks, :assigned_user_id
    change_table :tasks do |t|
      t.references :assigned_user
    end
    Task.all.each do |task|
      temp = task.assigned_to
      task.update_attributes! :assigned_user_id => temp
    end
  end

  def down
    remove_column :tasks, :assigned_user_id
  end
end
