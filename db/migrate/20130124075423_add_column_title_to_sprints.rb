class AddColumnTitleToSprints < ActiveRecord::Migration
  def change
    add_column :sprints, :title, :text
  end
end
