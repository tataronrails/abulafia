class AddColumnTypeOfWorkProjectMemberships < ActiveRecord::Migration
  def up
    add_column :project_memberships, :type_to_calculate, :string
  end

  def down
    remove_column :project_memberships, :type_to_calculate, :string
  end
end
