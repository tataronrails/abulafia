class AddColumnIsDepartmentToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :is_department, :boolean
  end
end
