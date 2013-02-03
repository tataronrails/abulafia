class ChangeColumnToTask < ActiveRecord::Migration
  def up
    change_table :tasks do |t|
      t.remove :status
      t.remove :task_type
      t.string :type
      t.string :status
      t.rename :end, :end_at
    end
  end

  def down
    change_table :tasks do |t|
      t.remove :type
      t.remove :status
      t.integer :status, :default => 0
      t.string :task_type
      t.rename :end_at, :end
    end
  end
end
