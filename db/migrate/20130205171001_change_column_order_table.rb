class ChangeColumnOrderTable < ActiveRecord::Migration
  def up
    change_table :column_orders do |t|
      t.remove :place_id
      t.rename :position_array, :positions
    end
  end

  def down
    change_table :column_orders do |t|
      t.integer :place_id
      t.rename :positions, :position_array
    end
  end
end
