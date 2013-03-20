class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.string :title, :null => false
      t.boolean :checked, :default => false
      t.references :task

      t.timestamps
    end
  end
end
