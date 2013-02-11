class AddIterationNumberToSprints < ActiveRecord::Migration
  def change
    add_column :sprints, :iteration_number, :integer
  end
end
