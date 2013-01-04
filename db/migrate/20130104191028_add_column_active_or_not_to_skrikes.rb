class AddColumnActiveOrNotToSkrikes < ActiveRecord::Migration
  def change
    add_column :strikes, :active_or_not, :boolean, :default => true
  end
end
