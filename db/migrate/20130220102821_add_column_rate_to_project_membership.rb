class AddColumnRateToProjectMembership < ActiveRecord::Migration
  def change
    add_column :project_memberships, :rate, :integer
  end
end
