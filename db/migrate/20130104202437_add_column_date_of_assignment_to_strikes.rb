class AddColumnDateOfAssignmentToStrikes < ActiveRecord::Migration
  def change
    add_column :strikes, :date_of_assignment, :datetime
  end
end
