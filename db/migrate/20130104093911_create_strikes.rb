class CreateStrikes < ActiveRecord::Migration
  def change
    create_table :strikes do |t|
      t.text :desc
      t.integer :assigned_by
      t.references :task
      t.references :user

      t.timestamps
    end
    add_index :strikes, :task_id
  end
end
