class CreateColumnOrders < ActiveRecord::Migration
  def change
    create_table :column_orders do |t|
      t.integer :project_id
      t.integer :place_id
      t.text :position_array
      #t.timestamps
    end
  end
end
