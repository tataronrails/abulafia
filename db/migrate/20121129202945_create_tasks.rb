class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.integer :status, :default => "0"
      t.integer :owner_id
      t.integer :assigned_to
      t.date :start
      t.date :end

      t.timestamps
    end
  end
end
