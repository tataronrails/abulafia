class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :filename
      t.integer :attachable_id
      t.string :attachable_type
      t.integer :filesize

      t.timestamps
    end
  end
end
