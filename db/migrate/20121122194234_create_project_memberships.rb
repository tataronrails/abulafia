class CreateProjectMemberships < ActiveRecord::Migration
  def change
    create_table :project_memberships do |t|
      t.references :project
      t.references :user
      t.string :role

      t.timestamps
    end
    add_index :project_memberships, :project_id
    add_index :project_memberships, :user_id
  end
end
