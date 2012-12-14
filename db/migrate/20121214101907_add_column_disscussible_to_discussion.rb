class AddColumnDisscussibleToDiscussion < ActiveRecord::Migration
  def change
    change_table :discussions do |t|
      t.references :discussable, :polymorphic => true
    end
  end
end
