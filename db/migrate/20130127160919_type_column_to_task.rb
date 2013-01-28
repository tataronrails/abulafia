class TypeColumnToTask < ActiveRecord::Migration
  def up
    change_table :tasks do |t|
      t.remove :status
      t.remove :task_type
      t.string :type
      t.string :status
    end
  end

  def down
    change_table :tasks do |t|
      t.remove :type
      t.remove :status
      t.integer :status, :default => 0
      t.string :task_type
    end
  end
end
