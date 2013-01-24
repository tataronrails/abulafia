class CreateSprints < ActiveRecord::Migration
  def change
    create_table :sprints do |t|
      t.date :start_at
      t.date :end_at
      t.text :desc
      t.references :project

      t.timestamps
    end
    add_index :sprints, :project_id
  end
end
