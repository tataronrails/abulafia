class CreateDiscussions < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
      t.string :title
      t.references :project

      t.timestamps
    end
    add_index :discussions, :project_id
  end
end
